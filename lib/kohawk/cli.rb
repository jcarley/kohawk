module Kohawk
  class CLI

    def start

      connect(:default) do |connection|

      end

    end

    def stop
      ConnectionManager.disconnect_all
    end


    private

    def connect(name)

    end

  end
end

