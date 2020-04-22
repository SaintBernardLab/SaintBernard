
#ifndef SBFRACTUREDARCYVELOCITYCOMPONENTLOWERDIMENSIONAL_H
#define SBFRACTUREDARCYVELOCITYCOMPONENTLOWERDIMENSIONAL_H

#include "PorousFlowDarcyVelocityComponent.h"

// Forward Declarations
class SBFractureDarcyVelocityComponentLowerDimensional;

template <>
InputParameters validParams<SBFractureDarcyVelocityComponentLowerDimensional>();

/**
 * Computes a component of the Darcy velocity:
 * -k_ij * krel /(mu a) (nabla_j P - w_j)
 * where k_ij is the permeability tensor,
 * krel is the relative permeaility,
 * mu is the fluid viscosity,
 * a is the fracture aperture,
 * P is the fluid pressure
 * and w_j is the weight fluid
 * This is measured in m^3 . s^-1 . m^-2
 */
class SBFractureDarcyVelocityComponentLowerDimensional : public PorousFlowDarcyVelocityComponent
{
public:
  SBFractureDarcyVelocityComponentLowerDimensional(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const VariableValue & _aperture;
};

#endif // SBFRACTUREDARCYVELOCITYCOMPONENTLOWERDIMENSIONAL_H
