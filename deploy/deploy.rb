# coding: utf-8
require "rubygems"
require "bundler/setup"
require "qiita"
require "json"

PARAMS_FILE_NAME = 'params.json'
ITEM_ID_FILE_NAME = 'ITEM_ID'
LOCK_FILE_NAME = 'LOCK'
BODY_FILE_NAME = 'README.md'

# 記事を保存しているディレクトリ
ITEMS_DIR = './items'

# Qiitaのアクセストークン設定
client = Qiita:: Client.new(access_token: ENV['QIITA_TOKEN'])

if Dir.exist?(ITEMS_DIR) then
  # Directoryを移動
  Dir.chdir(ITEMS_DIR)
  # 記事保存ディレクトリのフルパス記録
  ITEMS_DIR_FULL_PATH = Dir.pwd

  # '.'と'..'を除いて全フォルダに対してDeploy実行
  Dir.foreach(ITEMS_DIR_FULL_PATH){|dir|
    if dir=='.' or dir=='..' then
      p dir + ' is skipped.'
    else
      p '[' + dir + ']'
      # 各記事フォルダに移動
      Dir.chdir(dir)

      # LOCKが存在したらデプロイしない
      if File.exist?(LOCK_FILE_NAME) then
        p 'LOCK is existed. No deploy.'
      # README.mdが存在しなかったらデプロイしない
      elsif not File.exist?(BODY_FILE_NAME) then
        p 'README.md is not existed. No deploy.'
      else
        # 記事用のパラメータファイル読み込み
        params = File.open(PARAMS_FILE_NAME) do |file|
          JSON.load(file)
        end

        # Headersを設定
        headers = {'Content-Type' => 'application/json'}

        # 記事ファイル読み込み
        body = File.open(BODY_FILE_NAME) do |file|
          file.read
        end

        # 記事ファイルを設定
        params['body'] = body

        # ITEM_IDが存在したらその記事IDで記事を更新する。
        # 存在しなかったら新しい記事を作成する。
        if File.exist?(ITEM_ID_FILE_NAME) then
          item_id = File.open(ITEM_ID_FILE_NAME) do |file|
            file.read
          end
          p client.update_item(item_id, params, headers)
        else
          p client.create_item(params, headers)
        end
      end

      # 記事保存ディレクトリに戻る
      Dir.chdir(ITEMS_DIR_FULL_PATH)
    end
  }
end
