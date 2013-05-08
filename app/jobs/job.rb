module Job
  class Base
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  end
end
