# test darcy velocity in a 2D lower dimensional fracture with permeability computed from cubic law

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 3
  xmax = 1
  ymax = .3
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
[]

[Variables]
  [./pp]
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
[]

[ICs]
  [./pp]
    type = FunctionIC
    variable = pp
    function = 'x-1'
  [../]
  [./apertureIC]
    type = ConstantIC
    variable = aperture
    value = 1e-5
  [../]
[]

[BCs]
  [./top]
    type = PresetBC
    value = 0
    variable = pp
    boundary = right
  [../]
  [./bottom]
    type = PresetBC
    value = 1
    variable = pp
    boundary = left
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
    type = PorousFlow1PhaseFullySaturated
    porepressure = pp
  [../]
  [./massfrac_nodal]
    type = PorousFlowMassFraction
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  [../]
  [./poro]
    type = PorousFlowPorosityConst
    porosity = aperture
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
  [./permeability]
    type = SBFractureFlowPermeabilityConstFromVar
    aperture = aperture
  [../]
[]

[Preconditioning]
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
[]

[Outputs]
  [./out]
    type = Exodus
    execute_on = 'timestep_end'
  [../]
[]
