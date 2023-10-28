FROM postgres:latest

# viエディタのインストール
RUN apt-get update && apt-get install -y vim

# PostgreSQLの公式イメージは、/docker-entrypoint-initdb.d/ ディレクトリに配置されたスクリプトを初期化時に実行する
COPY ./init.sql /docker-entrypoint-initdb.d/
