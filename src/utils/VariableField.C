
#include "VariableField.h"
#include "MooseError.h"

#include <fstream>

VariableField::VariableField(std::string filename)
{
  std::ifstream file(filename.c_str());
  if (!file)
    mooseError("Error opening file: ", filename.c_str());

  // jump over first line which contains a comment about the data
  std::string tmps;
  std::getline(file, tmps);

  std::getline(file, tmps, '=');
  file >> nx;
  std::getline(file, tmps, '=');
  file >> ny;
  std::getline(file, tmps, '=');
  file >> nz;

  std::getline(file, tmps, '=');
  file >> dx;
  std::getline(file, tmps, '=');
  file >> dy;
  std::getline(file, tmps, '=');
  file >> dz;

  // go to next line
  std::getline(file, tmps);

  int number_pts = nx * ny * nz;
  data.resize(number_pts);

  // Index of array: [(z*ny + y)*nx + x]
  for (int i = 0; i < number_pts; i++)
    file >> data[i];
}

Real
VariableField::value(Point p)
{
  // calculate the bin for each point
  int x = int(p(0) / dx);
  int y = int(p(1) / dy);
  int z = int(p(2) / dz);

  // check for errors of values out of range
  if (x < 0 || nx - x <= 0)
    mooseError("Point outside of bound in VariableField: x = ", x);
  if (y < 0 || ny - y <= 0)
    mooseError("Point outside of bound in VariableField: y = ", y);
  if (z < 0 || nz - z <= 0)
    mooseError("Point outside of bound in VariableField: z = ", z);

  return data[(z * ny + y) * nx + x];
}
