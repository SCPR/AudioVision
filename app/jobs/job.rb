module Job
  class Base
    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    end
  end
end
