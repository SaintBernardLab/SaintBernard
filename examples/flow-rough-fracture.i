# steady-state flow through a rough fracture embedded in a impermeable rock matrix

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx =201
  ny =201
  xmax = 1.0
  ymax = 1.0
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
[]

[Variables]
  [./pp]
    initial_condition = 1e6
  [../]
[]

[AuxVariables]
  [./velocity_x]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./velocity_y]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./velocity_magnitude]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./flux_magnitude]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./aperture]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./velocity_x]
    type = SBFractureDarcyVelocityComponentLowerDimensional
    variable = velocity_x
    component = x
    aperture = aperture
  [../]
  [./velocity_y]
    type = SBFractureDarcyVelocityComponentLowerDimensional
    variable = velocity_y
    component = y
    aperture = aperture
  [../]
  [./magnitude]
    type = VectorMagnitudeAux
    variable = velocity_magnitude
    x = velocity_x
    y = velocity_y
  [../]
  [./fluxvals]
    type = ParsedAux
    variable = flux_magnitude
    args = "velocity_magnitude aperture"
    function = "velocity_magnitude*aperture"
  [../]
[]


[ICs]
  [./aperture_input]
    type = SBParameterFieldIC
    variable = aperture
    file_name = ParameterField.txt
  [../]
[]

[BCs]
  [./injection]
    type = PorousFlowSink
    variable = pp
    boundary = left
    flux_function = -1.0e-5
  [../]
  [./production]
    type = PorousFlowPiecewiseLinearSink
    variable = pp
    boundary =  right
    pt_vals = '0 1e1'
    multipliers = '0 1e8'
    PT_shift = 1e6
    mass_fraction_component = 0
    use_mobility = true
    fluid_phase = 0
  [../]
[]

[Kernels]
  [./adv0]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = pp
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
  [./pc]
    type = PorousFlowCapillaryPressureConst
  [../]
[]

[Modules]
  [./FluidProperties]
    [./simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 2e9
      density0 = 1000
      thermal_expansion = 0
      viscosity = 1e-3
    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
  [../]
  [./ppss_qp]
    type = PorousFlow1PhaseP
    porepressure = pp
    capillary_pressure = pc
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  [../]
  [./relp]
    type = PorousFlowRelativePermeabilityConst
    phase = 0
  [../]
  [./relp_nodal]
    type = PorousFlowRelativePermeabilityConst
    phase = 0
    at_nodes = true
  [../]
  [./permeability]
    type = SBFractureFlowPermeabilityConstFromVar
    aperture = aperture
  [../]
[]

[Preconditioning]
  active = 'smp'
  [./mumps]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu mumps'
  [../]
  [./smp]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres      asm      lu           NONZERO                   2             '
  [../]
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
# controls for linear iterations
  l_max_its = 15
  l_tol = 1e-10

# controls for nonlinear iterations
  nl_max_its = 20
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-10
[]

[Outputs]
  [./out]
    type = Exodus
    execute_on = 'timestep_end'
  [../]
[]
