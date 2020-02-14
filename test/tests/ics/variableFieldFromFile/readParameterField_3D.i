[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 8
  ny = 8
  nz = 8
  xmax = 1.
  ymax = 1.
  zmax = 1.
[]


[Variables]
  [./pressure]
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
    variable = pressure
  [../]
[]

[ICs]
  [./phi]
    type = ParameterFieldIC
    variable = phi
    file_name = ParameterField_3D.txt
  [../]
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
