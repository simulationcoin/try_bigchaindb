require_relative 'env'

DB = Rethink.new
B  = Bigchain.new

class BigchainApi < Roda
  plugin :json
  plugin :not_found
  plugin :indifferent_params

  route do |r|
    r.root do
      r.redirect "/blocks/last"
    end

    r.on "blocks" do
      r.get do
        r.is do
          DB.blocks
        end

        r.on "last" do
          DB.blocks_last
        end
      end
    end

    r.on "keys" do
      r.post do
        r.is do
          B.keys_new
        end
      end
    end

    r.on "assets" do
      r.on "admin" do
        r.post do
          r.is do
            B.assets_new_admin
          end
        end
      end

      r.on ":id" do |id|
        # TODO:
        # r.get do
        #   # B.asset 1
        #   { id: 1 }
        # end

        r.post do
          r.on "admin" do
            r.is do
              asset = params[:data]
              B.assets_transact_admin id, asset
            end
          end

          # r.is do
          #   B.assets_transact
          # end
        end
      end

      r.is do
        r.get do
          [{ id: 1 }]
          # B.assets
        end
      end

      # r.post do
      #   B.assets_new
      # end
    end

  end

  not_found do
    { error: :not_found, message: "404 - Route not present"}
  end
end
