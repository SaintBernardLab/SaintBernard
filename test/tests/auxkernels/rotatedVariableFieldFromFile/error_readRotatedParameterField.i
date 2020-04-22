[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 30
  ny = 30
  nz = 30
[]

[Variables]
  [./u]
    initial_condition = 0
  [../]
[]

[AuxVariables]
  [./phi]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./diffu]
    type = Diffusion
    variable = u
  [../]
[]

[AuxKernels]
  [./phi_field1]
    type = SBRotatedParameterFieldAux
    variable = phi
    file_name = ParameterField.txt
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
