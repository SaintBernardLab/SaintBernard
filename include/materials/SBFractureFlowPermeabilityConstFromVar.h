/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef SBFRACTUREFLOWPERMEABILITYCONSTFROMVAR_H
#define SBFRACTUREFLOWPERMEABILITYCONSTFROMVAR_H

#include "PorousFlowPermeabilityBase.h"

// Forward Declarations
class SBFractureFlowPermeabilityConstFromVar;

template <>
InputParameters validParams<SBFractureFlowPermeabilityConstFromVar>();

/**
 * Material to provide permeability calculated from a variable representing a fracture aperture.
 * This material is primarily designed for use with heterogeneous fracture aperture models
 * where the aperture is provided by an
 * elemental aux variables that does not change.
 * The three diagonal entries corresponding to the x, y, and z directions
 * are assumed to be equal and calculated using the cubic law.
 */
class SBFractureFlowPermeabilityConstFromVar : public PorousFlowPermeabilityBase
{
public:
  SBFractureFlowPermeabilityConstFromVar(const InputParameters & parameters);

protected:
  void computeQpProperties() override;

  /// Fracture aperture
  const VariableValue & _aperture;
};

#endif // SBFRACTUREFLOWPERMEABILITYCONSTFROMVAR_H
