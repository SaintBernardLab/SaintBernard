#include "SaintBernardApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
SaintBernardApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy DirichletBC, that is, set DirichletBC default for preset = true
  params.set<bool>("use_legacy_dirichlet_bc") = false;

  return params;
}

SaintBernardApp::SaintBernardApp(InputParameters parameters) : MooseApp(parameters)
{
  SaintBernardApp::registerAll(_factory, _action_factory, _syntax);
}

SaintBernardApp::~SaintBernardApp() {}

void
SaintBernardApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"SaintBernardApp"});
  Registry::registerActionsTo(af, {"SaintBernardApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
SaintBernardApp::registerApps()
{
  registerApp(SaintBernardApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
SaintBernardApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SaintBernardApp::registerAll(f, af, s);
}
extern "C" void
SaintBernardApp__registerApps()
{
  SaintBernardApp::registerApps();
}
