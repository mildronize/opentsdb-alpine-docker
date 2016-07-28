
storage_path := $(HOME)/external/hbase

up:
	docker-compose up -d

down:
	docker-compose down

clean: down
	sudo rm -rf $(storage_path)

backup:
	rsync -aAXr --progress --human-readable $(storage_path) $(storage_path).backup

restore:
	rsync -aAXr --progress --human-readable $(storage_path).backup $(storage_path)
