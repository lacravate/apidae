# encoding: utf-8

# I didn't want to use templates and templating system. 
# Piling up HTML strings in an array was sufficient. 

# But i figured out that, lean as the application and its rendering might
# be, i can't decently use anything HTML that hasn't got a minimal layout

# So i more or less coded my own templating system... No !!!

module Apidae

  module Wax

    # merely an array with a very few addenda
    class Assemblage < Array
 
      # base64-encoded layout
      @@construct = "PGh0bWw+CiAgPGhlYWQ+CiAgICA8dGl0bGU+CiAgICAgIEFwaWRhZSBIaXZl\nIC0gCiAgICA8L3RpdGxlPgogIDwvaGVhZD4KICA8Ym9keT4KCiAgPC9ib2R5\nPgo8L2h0bWw+Cg==\n"

      attr_accessor :body, :title, :title_stub

      def initialize(*args)
        super

        # at initialize, we fill the array with layout lines
        construct.each_with_index do |value, index|
          self[index] = value

          # Ok laugh... In the layout above, the body is where an
          # empty line is found.
          @body = value if value =~ /^$/

          # title stub is the line after the title tag
          @title = @title_stub = value if self[index - 1] && self[index - 1] =~ /^\s*<title>\s*$/
        end
      end

      # shunt Array '<<' method to actually make a push (concatenate) on
      # the Array element containing the body
      def <<(body_parts)
        # tap because i like tap
        # Yeah, and because vanilla '<<' returns self
        tap do |assemblage|
          assemblage.body.concat Array(body_parts).join
        end
      end

      private

      # base64 to string returning an array of lines thank to a neat
      # String method
      def construct
        @construct ||= Base64.decode64(@@construct).lines.to_a
      end

    end

  end

end
