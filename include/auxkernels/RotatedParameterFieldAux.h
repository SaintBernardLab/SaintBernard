
#ifndef ROTATEDPARAMETERFIELDAUX_H
#define ROTATEDPARAMETERFIELDAUX_H

#include "AuxKernel.h"
#include "VariableField.h"

class RotatedParameterFieldAux;
// class MooseMesh;

template <>
InputParameters validParams<RotatedParameterFieldAux>();

class RotatedParameterFieldAux : public AuxKernel
{
public:
  RotatedParameterFieldAux(const InputParameters & parameters);
  virtual ~RotatedParameterFieldAux(){};

protected:
  virtual Real computeValue();

private:
  Real _x_min = std::numeric_limits<Real>::max();
  Real _x_max = -std::numeric_limits<Real>::max();
  Real _y_min = std::numeric_limits<Real>::max();
  Real _y_max = -std::numeric_limits<Real>::max();

  VariableField _var_field;
  Real _block_id;
  Real _alphaX;
  Real _alphaY;
  Point _orig;
  Real _x_scale;
  Real _y_scale;
  Real _scale;
  Point _mesh_origin;
};

#endif // ROTATEDPARAMETERFIELDAUX_H
