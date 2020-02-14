#include "ParameterFieldIC.h"

registerMooseObject("SaintBernardApp", ParameterFieldIC);

template <>
InputParameters
validParams<ParameterFieldIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<std::string>("file_name",
                                       "The name of the file that contains one variables values");
  return params;
}

ParameterFieldIC::ParameterFieldIC(const InputParameters & parameters)
  : InitialCondition(parameters), _stoch_field(getParam<std::string>("file_name"))
{
}

Real
ParameterFieldIC::value(const Point & /*p*/)
{
  return _stoch_field.value(_current_elem->centroid());
}
