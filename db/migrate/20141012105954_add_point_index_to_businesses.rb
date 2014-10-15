class AddPointIndexToBusinesses < ActiveRecord::Migration
	def up
		execute %{
			create index index_on_businesses_location ON businesses using gist (
				ST_GeographyFromText(
					'SRID=4326;POINT(' || businesses.longitude || ' ' || businesses.latitude || ')'
				)
			)
		}
	end

	def down
		execute %{drop index index_on_businesses_location}
	end
end
