
require 'csv'

puts "番号を入力してください\e[32m（1: 新規でCSVメモ作成, 2: 既存のCSVメモを編集する, 3: プログラム終了） \e[0m"
input_user_value = gets.chomp

#create csv
def create_file_process

  puts "--新規メモを作成します。拡張子・記号を除いたメモの名前を入力してください--"
  input_user_filename = gets.chomp

  if (input_user_filename.empty? || input_user_filename.match?(/\A[\p{P}\p{S}\s]+\z/))
    puts "\e[31m 不正なファイル名です。\e[0m"
    exit
  end

  create_filename = "#{input_user_filename}.csv"
  search_file = File.exist?(create_filename)

  if(search_file == false)
    puts "#{create_filename}を作成します"
    puts "メモしたい内容を入力してください、メモが終わったらEnterキーを押下してください"
    
    input_user_filedate = gets.chomp
      CSV.open(create_filename, 'w',encoding: 'UTF-8') do |csv|
      csv << [input_user_filedate]
    end

  else
    puts "\e[31m #{create_filename}はすでに使われている名前です。プログラムを終了します \e[0m"
    exit
  end
end

#change csv
def update_file_process

  puts "--更新したいメモの名前を、拡張子を除いたメモの名前を入力してください--"
  input_user_filename = gets.chomp
  change_filename = "#{input_user_filename}.csv"

  unless File.exist?(change_filename)
  puts "#{change_filename} は存在しません。終了します。"
  exit
  end

    puts "#{change_filename}を編集します"
    puts "番号を入力してください\e[32m（1: 既存内容の編集, 2: 既存内容に追加, 3: 既存内容を削除） \e[0m"
    input_user_changevalue = gets.chomp
    
  case input_user_changevalue
    
   when "1"
    csv_date = CSV.read(change_filename, encoding: 'UTF-8')
    puts "\n---#{change_filename}のメモ内容---"
    csv_date.each_with_index do |row, index|
      puts "行番号#{index}:#{row}"
    end

    puts "編集したい行番号を選択してください"
    input_change_line = gets.chomp.to_i

    if input_change_line < 0 || input_change_line >= csv_date.size
      puts "\e[32m 不正な行番号です。処理を中止します。 \e[0m"
      exit
    end

    puts "メモしたい内容を入力してください。メモが終わったらEnterキーを押下してください"
    input_change_filedate = gets.chomp
    csv_date[input_change_line] = [input_change_filedate]

    CSV.open(change_filename, 'w',encoding: 'UTF-8') do |csv|
      csv_date.each { |row| csv << row }
    end
    puts "変更しました。"

  when "2"
  puts "新しいメモを追加します。メモが終わったらEnterキーを押下してください"
  input_change_filedate = gets.chomp
  CSV.open(change_filename, 'a',encoding: 'UTF-8') do |csv|
  csv << [input_change_filedate]
  puts "#{input_change_filedate}を追加しました。"
  end

  when "3"
    csv_date = CSV.read(change_filename, encoding: 'UTF-8')
    puts "\n---#{change_filename}のメモ内容---"
    csv_date.each_with_index do |row, index|
      puts "行番号#{index}:#{row}"
    end

    puts "削除したい行番号を選択してください。"
    input_delete_line = gets.chomp.to_i

    if input_delete_line < 0 || input_delete_line >= csv_date.size
      puts "\e[32m 不正な行番号です。処理を中止します。 \e[0m"
      exit
    end

    csv_date.delete_at(input_delete_line)
    CSV.open(change_filename, 'w',encoding: 'UTF-8') do |csv|
      csv_date.each { |row| csv << row }
    end
    puts "削除しました。"

  
  else
    puts "\e[31m 不正な入力です。プログラムを終了します \e[0m"
    exit
  end
end

#user select menu
case input_user_value

when "1"
  create_file_process()
when "2"
  update_file_process()
when "3"
  puts "プログラムを終了します。"
  exit
else
  puts "\e[31m 不正な入力です。プログラムを終了します \e[0m"
  exit
end
