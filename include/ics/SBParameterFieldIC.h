
#ifndef SBPARAMETERFIELDIC_H
#define SBPARAMETERFIELDIC_H

#include "InitialCondition.h"
#include "VariableField.h"

class InputParameters;
class SBParameterFieldIC;
namespace libMesh
{
class Point;
}

template <typename T>
InputParameters validParams();

template <>
InputParameters validParams<SBParameterFieldIC>();

class SBParameterFieldIC : public InitialCondition
{
public:
  SBParameterFieldIC(const InputParameters & parameters);
  virtual Real value(const Point & p) override;

private:
  VariableField _var_field;
};

#endif // SBPARAMETERFIELDIC_H
