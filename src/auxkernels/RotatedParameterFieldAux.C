
#include "MooseMesh.h"
#include "Assembly.h"
#include "RotatedParameterFieldAux.h"

registerMooseObject("SaintBernardApp", RotatedParameterFieldAux);

template <>
InputParameters
validParams<RotatedParameterFieldAux>()
{
  InputParameters params = validParams<AuxKernel>();

  params.addRequiredParam<std::string>(
      "file_name", "The name of the file that contains values of one parameter");
  params.addParam<Real>("block_nb", 0, "The Block ID on which the parameters are projected");

  return params;
}

RotatedParameterFieldAux::RotatedParameterFieldAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _var_field(getParam<std::string>("file_name")),
    _block_id(getParam<Real>("block_nb"))
{
  bool calc_alpha = true;
  for (auto elem_it = _mesh.activeLocalElementsBegin(); elem_it != _mesh.activeLocalElementsEnd();
       ++elem_it)
  {
    if ((*elem_it)->subdomain_id() == _block_id)
    {
      if (calc_alpha)
      {
        if ((*elem_it)->dim() != 2)
        {
          mooseError("The method only works for 2D objects. Please consider to use an other method "
                     "to project a parameter field onto a ",
                     (*elem_it)->dim(),
                     " dimensional object");
        }
        _orig = Point((*elem_it)->node_ptr(0)[0]);
        const Point pt2 = Point((*elem_it)->node_ptr(1)[0]);
        const Point pt3 = Point((*elem_it)->node_ptr(2)[0]);
        Point n1 = (_orig - pt2).cross(_orig - pt3);
        if (n1(2) < 0.)
        {
          n1 *= -1.;
        }
        _alphaX = std::acos(n1(2) / Point(n1(0), 0., n1(2)).norm());
        const Point nt = Point(std::cos(_alphaX) * n1(0) - std::sin(_alphaX) * n1(2),
                               n1(1),
                               std::sin(_alphaX) * n1(0) + std::cos(_alphaX) * n1(2));
        _alphaY = std::acos(nt(2) / Point(0., nt(1), nt(2)).norm());
        calc_alpha = false;
      }
      for (unsigned int n = 0; n < (*elem_it)->n_nodes(); ++n)
      {
        const Node * node = (*elem_it)->node_ptr(n);
        //        std::cout << "node: " << node[0] << "\n";
        const Point n_temp = node[0]; //-_orig;
        const Point n_temp1 = Point(std::cos(_alphaX) * n_temp(0) - std::sin(_alphaX) * n_temp(2),
                                    n_temp(1),
                                    std::sin(_alphaX) * n_temp(0) + std::cos(_alphaX) * n_temp(2));
        const Point n_temp2 =
            Point(n_temp1(0),
                  std::sin(_alphaY) * n_temp1(2) + std::cos(_alphaY) * n_temp1(1),
                  std::cos(_alphaY) * n_temp1(2) - std::sin(_alphaY) * n_temp1(1));
        //        std::cout << "pt  : " << n_temp2 << "\n";
        if (n_temp2(0) < _x_min)
          _x_min = n_temp2(0);
        if (n_temp2(0) > _x_max)
          _x_max = n_temp2(0);
        if (n_temp2(1) < _y_min)
          _y_min = n_temp2(1);
        if (n_temp2(1) > _y_max)
          _y_max = n_temp2(1);
      }
    }
  }

  const Real _mesh_x_length = _x_max - _x_min;
  const Real _mesh_y_length = _y_max - _y_min;
  _x_scale = (_var_field.nx * _var_field.dx) / _mesh_x_length;
  _y_scale = (_var_field.ny * _var_field.dy) / _mesh_y_length;
  _scale = std::min(_x_scale, _y_scale);
  _mesh_origin = Point(_x_min, _y_min, 0.);
  //  std::cout << "_scale: " << _scale << "\n";
  //  std::cout << "_mesh_origin: " << _mesh_origin << "\n";
  //  std::cout << "_alphaX: " << _alphaX << "\n";
  //  std::cout << "_alphaY: " << _alphaY << "\n";
}

Real
RotatedParameterFieldAux::computeValue()
{
  // rotate point
  const Point pt = _current_elem->centroid();
  const Point pt1 = Point(std::cos(_alphaX) * pt(0) - std::sin(_alphaX) * pt(2),
                          pt(1),
                          std::sin(_alphaX) * pt(0) + std::cos(_alphaX) * pt(2));
  const Point pt2 = Point(pt1(0),
                          std::sin(_alphaY) * pt1(2) + std::cos(_alphaY) * pt1(1),
                          std::cos(_alphaY) * pt1(2) - std::sin(_alphaY) * pt1(1));

  // shift point
  const Point pt3 =
      Point(_scale * (pt2(0) - _mesh_origin(0)), _scale * (pt2(1) - _mesh_origin(1)), 0.);
  //  std::cout << "pt0;" << pt << "\n";
  //  std::cout << "pt3;" << pt3 << "\n";
  return _var_field.value(pt3);
}
