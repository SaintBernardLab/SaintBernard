#include "SBParameterFieldIC.h"

registerMooseObject("SaintBernardApp", SBParameterFieldIC);

template <>
InputParameters
validParams<SBParameterFieldIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<std::string>("file_name",
                                       "The name of the file that contains one variables values");
  return params;
}

SBParameterFieldIC::SBParameterFieldIC(const InputParameters & parameters)
  : InitialCondition(parameters), _var_field(getParam<std::string>("file_name"))
{
}

Real
SBParameterFieldIC::value(const Point & /*p*/)
{
  return _var_field.value(_current_elem->centroid());
}
