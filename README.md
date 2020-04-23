SaintBernard
=====

A MOOSE Application to model flow and transport through lower dimensional rough fractures.
- *The governing equations are solved with the MOOSE PorousFlow module and a great documentation is given on: [https://mooseframework.org/modules/porous_flow/index.html](https://mooseframework.org/modules/porous_flow/index.html).*
- *The focus of here is on the two-dimensional representation of fractures, which means in detail:*
  - *read in aperture fields from text files*
  - *apply aperture values to a 2D fracture domain and calculate permeability following the cubic law*
  - *compute the respective Darcy velocities*

#### Examples
Next to the necessary code to handle lower dimensional aperture fields, this repository provides example simulations of flow and transport through rough fractures.
Such example input files are described [here](examples/README.md).

Install
---
SaintBernard is a MOOSE application which requires to install MOOSE first. This can be done following: [https://mooseframework.org/getting_started/index.html](https://mooseframework.org/getting_started/index.html). As the governing equations are solved with the PorousFlow module, it should also be built and tested. For information on this, please visit: [https://github.com/idaholab/moose/tree/next/modules/porous_flow](https://github.com/idaholab/moose/tree/next/modules/porous_flow).

After MOOSE and the PorousFlow module are successfully built and tested we can build SaintBernard, which is done by:

`cd <path_to_saintbernard> ; make`

To speed this up one can use `make -j8`, where `8` is the number of cores available. If the respective system has more or less this should be adapted.

Testing
---
To test if SaintBernard works fine on your system, please run the tests with the following command:

`cd <path_to_saintbernard> ; ./run_tests`

Here, the option for speedup is similar to above (e.g. `./run_tests -j8`).

For more information on the MOOSE framework see: [http://mooseframework.org](http://mooseframework.org)

Contact
---
For contact please visit: [https://geg.ethz.ch/philipp-schaedle/](https://geg.ethz.ch/philipp-schaedle/)
