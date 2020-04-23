
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 201
  ny = 201
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
    scaling = 1e2
  [../]
  [./tracer]
    initial_condition = 0.
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
  [./flux_water]
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
    variable = flux_water
    args = "velocity_magnitude aperture"
    function = "velocity_magnitude*aperture"
  [../]
[]

[Functions]
  [./tracerfunc]
    type = PiecewiseConstant
    x = '0      59    1e9'
    y = '-1.e-7 0     0'
    direction = left
  [../]
  [./waterfunc]
    type = PiecewiseConstant
    x = '0        59      1e9'
    y = '-9.9e-6 -1.e-5  -1.e-5'
    direction = left
  [../]
[]

[ICs]
  [./apertureval]
    type = SBParameterFieldIC
    variable = aperture
    file_name = ParameterField.txt
  [../]
[]

[BCs]
  [./trinjection]
    type = PorousFlowSink
    variable = tracer
    boundary = left
    fluid_phase = 0
    flux_function = waterfunc
  [../]
  [./trproduction]
    type = PorousFlowPiecewiseLinearSink
    variable = tracer
    boundary =  right
    pt_vals = '0 1e1'
    multipliers = '0 1e8'
    PT_shift = 1e6
    mass_fraction_component = 1
    use_mobility = true
    fluid_phase = 0
  [../]
  [./injection]
    type = PorousFlowSink
    variable = pp
    boundary = left
    flux_function = tracerfunc
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
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  [../]
  [./adv0]
    type = PorousFlowFluxLimitedTVDAdvection
    advective_flux_calculator = advective_flux_calculator_0
    variable = pp
  [../]
  [./mass1]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = tracer
  [../]
  [./adv1]
    type = PorousFlowFluxLimitedTVDAdvection
    advective_flux_calculator = advective_flux_calculator_1
    variable = tracer
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp tracer'
    number_fluid_phases = 1
    number_fluid_components = 2
  [../]
  [./pc]
    type = PorousFlowCapillaryPressureConst
  [../]
  [./advective_flux_calculator_0]
    type = PorousFlowAdvectiveFluxCalculatorSaturatedMultiComponent
    flux_limiter_type = VanLeer
    fluid_component = 0
  [../]
  [./advective_flux_calculator_1]
    type = PorousFlowAdvectiveFluxCalculatorSaturatedMultiComponent
    flux_limiter_type = VanLeer
    fluid_component = 1
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
  [./permeability]
    type = SBFractureFlowPermeabilityConstFromVar
    aperture = aperture
  [../]
  [./poro]
    type = PorousFlowPorosityConst
    porosity = aperture
  [../]
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
    mass_fraction_vars = 'tracer'
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
    at_nodes = true
    phase = 0
  [../]
[]

[Preconditioning]
  [./mumps]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu mumps'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  end_time = 5e3
  dtmax = 10
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    optimal_iterations = 6
    time_t  = '0  60'
    time_dt = '1  1'
  [../]

# controls for linear iterations
  l_max_its = 15
  l_tol = 1e-10

# controls for nonlinear iterations
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
[]

[Outputs]
  [./out]
    type = Exodus
    execute_on = 'initial timestep_end'
  [../]
[]
