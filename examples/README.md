## Example simulations for flow and transport through fractures

These input files and results demonstrate on simple examples how flow and transport through fractures with variable apertures can be computed.

The governing equations are solved with Kernels provided by the PorousFlow module (see: [https://mooseframework.org/modules/porous_flow/index.html](https://mooseframework.org/modules/porous_flow/index.html)).

### Single phase flow through a fracture with variable aperture

The full input file is in [flow-rough-fracture.i](flow-rough-fracture.i)

This model computes fluid flow through a fracture with variable aperture.
On the left side of the domain fluid is injected with a constant injection flow rate. On the right side of the domain the pressure is fixed, which results in a sink and fluid production.
The mean aperture is 1e-5 [m] and the aperture values are distributed with respecting a correlation length of 0.1 [m].
Next to the Darcy velocity [m/s] a flux [m2/s] is calculated as an output.

#### SaintBernard specific syntax
In order to read aperture from a text file the `InitialCondition` `SBParameterFieldIC` can be used. This applies the values given in a text file to an `AuxVariable` for aperture.
```
[ICs]
  [./aperture_input]
    type = SBParameterFieldIC
    variable = aperture
    file_name = ParameterField.txt
  [../]
[]
```
The syntax of the parameter file should be as follows:
```
// property field
nx = 2 , ny = 2 , nz = 1
dx = 0.5 , dy = 0.5 , dz = 1
1.0
2.0
3.0
4.0
```
`SBParameterFieldIC` creates a matrix with parameter values of dimension nx x ny x nz.
Whereby, dx, dy, and dz are the width of each entry in this matrix.
The parameter values are provided as a list, which is created by iterating over x, y, and z directions.

To compute fluid flow the corresponding permeability `Material` needs to be provided.
Therefore, the aperture `AuxVariable` is used in the `SBFractureFlowPermeabilityConstFromVar`. This material computes the permeability from an aperture variable using the cubic law k=a^3/12. Here, it is important to note that the resulting permeability is already multiplied by the aperture values, as should be done for lower dimensional domains (the logic can be found here: [https://mooseframework.org/modules/porous_flow/flow_through_fractured_media.html](https://mooseframework.org/modules/porous_flow/flow_through_fractured_media.html))

```
[Materials]
  [./permeability]
    type = SBFractureFlowPermeabilityConstFromVar
    aperture = aperture
  [../]
[]
```
Using the material `SBFractureFlowPermeabilityConstFromVar` the permeability is multiplied by the aperture. Therefore, the Darcy velocity needs to be divided by the aperture to be correct. This is done by the `AuxKernel` `SBFractureDarcyVelocityComponentLowerDimensional`, where the aperture `AuxVariable` can be provided. With the aperture `AuxVariable` give the Darcy velocity is computed with units [m/s]. If no aperture `AuxVariable` is give a flux with units [m2/s] is computed.
```
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
```
### Single phase flow and advective transport through a fracture with variable aperture

The full input file is in [flow-transport-rough-fracture.i](flow-transport-rough-fracture.i)

Based in the setup described above advective transport of a tracer is added to the model.
Here, the `PorousFlow` option `PorousFlowFluxLimitedTVDAdvection` is used to prevent numerical diffusion in the tracer transport computation.
The following gif shows the flux results and the tracer as it travels through the domain.

![Figure of flux and gif of mass fraction](media/transport_vid/transport_vid.gif)

The mass fraction nicely demonstrates how the tracer follows the path of high fluxes. Furthermore, tracer is delayed in areas with low flux values, which are areas with low velocity and low aperture values.
