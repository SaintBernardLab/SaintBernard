# flow and solute transport along a fracture in a porous matrix
# advective dominated flow in the fracture and diffusion into the porous matrix

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 3
  ny = 3
  xmax = 1
  ymax = 1
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
  [./aperture]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./get_coeff_c]
    type = FunctionAux
    variable = aperture
    function = '6e-1*t'
    execute_on = 'timestep_begin'
  [../]
[]

[ICs]
  [./pp]
    type = ConstantIC
    variable = pp
    value = 1e6
  [../]
[]

[BCs]
  [./top]
    type = PresetBC
    value = 0
    variable = pp
    boundary = top
  [../]
  [./bottom]
    type = PresetBC
    value = 1
    variable = pp
    boundary = bottom
  [../]
[]

[Kernels]
  [./mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  [../]
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
  type = Transient
  solve_type = NEWTON
  dt = 0.001
  end_time = 0.005
[]

[Outputs]
  [./out]
    type = Exodus
    execute_on = 'timestep_end'
    output_material_properties = true
    show_material_properties = "PorousFlow_permeability_qp PorousFlow_porosity_qp"
  [../]
[]
