
storage_path := $(HOME)/external/hbase
restore_path := $(HOME)/external
container_name := opentsdb

# START

start: up load_dps

up:
	docker-compose up -d

load_dps:
	docker cp $(HOME)/external/logs/generated-dps opentsdb:/opt/opentsdb/opentsdb-2.2.0/build

make_metric:
	docker exec -it $(container_name) ./tsdb mkmetric level

# DESTROY

down:
	docker-compose down

remove_logs:
	rm -rIv ./logs import_log.csv

clean:
	sudo rm -rf $(storage_path)

# BACKUP

backup:
	rsync -aAXr --progress --human-readable $(storage_path) $(storage_path).backup.rsync

restore:
	sudo rm -rf $(storage_path)
	sudo rsync -aAXr --progress --human-readable $(storage_path).backup.rsync/hbase $(restore_path)

not_create_table:
	docker exec -it $(container_name) touch /opt/opentsdb_tables_created.txt
