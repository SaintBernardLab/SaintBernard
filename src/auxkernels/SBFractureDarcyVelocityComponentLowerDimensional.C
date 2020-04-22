
#include "SBFractureDarcyVelocityComponentLowerDimensional.h"
#include "MooseMesh.h"
#include "Assembly.h"

registerMooseObject("SaintBernardApp", SBFractureDarcyVelocityComponentLowerDimensional);

template <>
InputParameters
validParams<SBFractureDarcyVelocityComponentLowerDimensional>()
{
  InputParameters params = validParams<PorousFlowDarcyVelocityComponent>();
  params.addCoupledVar("aperture", 1.0, "Aperture of the fracture");
  params.addClassDescription(
      "Darcy velocity in a lower-dimensional element.(m^3.s^-1.m^-2, or m.s^-1)."
      "Darcy velocity =  -(k_ij * krel /(mu * a) (nabla_j P - w_j)), "
      "where k_ij is the permeability tensor, krel is the relative permeability, mu is the fluid "
      "viscosity, P is the fluid pressure, a is the fracture aperture and w_j is the fluid "
      "weight. ");
  return params;
}

SBFractureDarcyVelocityComponentLowerDimensional::SBFractureDarcyVelocityComponentLowerDimensional(
    const InputParameters & parameters)
  : PorousFlowDarcyVelocityComponent(parameters), _aperture(coupledValue("aperture"))
{
}

Real
SBFractureDarcyVelocityComponentLowerDimensional::computeValue()
{
  return -(_permeability[_qp] * (_grad_p[_qp][_ph] - _fluid_density_qp[_qp][_ph] * _gravity) *
           _relative_permeability[_qp][_ph] / _fluid_viscosity[_qp][_ph])(_component) /
         _aperture[_qp];
}
