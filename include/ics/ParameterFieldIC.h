
#ifndef PARAMETERFIELDIC_H
#define PARAMETERFIELDIC_H

#include "InitialCondition.h"
#include "VariableField.h"

class InputParameters;
class ParameterFieldIC;
namespace libMesh
{
class Point;
}

template <typename T>
InputParameters validParams();

template <>
InputParameters validParams<ParameterFieldIC>();

class ParameterFieldIC : public InitialCondition
{
public:
  ParameterFieldIC(const InputParameters & parameters);
  virtual Real value(const Point & p) override;

private:
  VariableField _stoch_field;
};

#endif // PARAMETERFIELDIC_H
