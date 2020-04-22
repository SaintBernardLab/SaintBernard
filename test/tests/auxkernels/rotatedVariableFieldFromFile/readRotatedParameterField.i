[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  xmax = 1.
  ymax = 1.
[]

[MeshModifiers]
  [./rotate]
    type = Transform
    transform = ROTATE
    vector_value = '45 45 45'
  [../]
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
    output_dimension = 3
    execute_on = 'timestep_end'
  [../]
[]
