# Программа позволяет пользователю пройти тест на знания по сноубордингу.
# Вопросы заранее подготовлены в файле формата YAML
# Ответы и итоги сохраняются в текстовом файле TXT

require 'yaml' # встроенная библиотека для работы с YAML
a_code = "A".ord # код символа в кодировке UTF-8 => 65
correct_answers = 0 # Счётчик правильных ответов
incorrect_answers = 0 # Счётчик неправильных ответов

# Ввести имя с клавиатуры
puts "Введите ваше имя: \n"
name = gets.strip

current_time = Time.now.strftime("%d-%m-%y_%H-%M-%S")
filename = "QUIZ_#{name}_#{current_time}.txt" # имя файла в формате QUIZ_ИМЯ_ГГГГ-ММ-ДД_ЧЧ-ММ-СС

File.write(
  filename, 
  "\nТест сдан: #{current_time}\nРезультат для пользователя: #{name}",
  mode: "a"
  ) # записывает данные в файл,  mode a - добавить в конец файла (режим)

# Берём заранее подготовленные вопросы из YAML файла
file_way = File.expand_path("snowboard_questions.yml", __dir__) # возвращает полный путь к файлу
all_questions = YAML.safe_load_file(file_way, symbolize_names: true) 
# только читает YAML-файл и возвращает Ruby-объект 

# Берёт каждый вопопрос и предлагает 4 варианта ответа
all_questions.shuffle.each do |question_data|
  # На каждой иттерации выводиться текст вопроса и ВСЕ 4 ответа
  formatted_question = "\n\n=== #{question_data[:question]} ===\n\n"
  puts formatted_question
  
  File.write(
    filename, 
    formatted_question,
    mode: "a"
    )


  # Тут храниться не буква ответа, а сам текст ответа
  # вопрос с правильным ответом всегда первый в массиве
  correct_answer = question_data[:answers].first 

  answers = question_data[:answers].shuffle.each_with_index.inject({}) do |result, (answer, index)| # inject - преобразует массив в один объект
    # На кажой иттерации мы выводим по 1 ответу
    # А = Ответ 1, B = Ответ 2 итд
    answer_char = (a_code + index).chr # преобразует код UTF-8 в символ
    result[answer_char] = answer
    # А. Ответ 1
    puts "#{answer_char}. #{answer}"

    result # теперь использует новое значение хеша для result
  end

user_answer_char = nil # переменная для хранения ответа

# Юзер вводит ответ
loop do # цикл запрашивает ввод с клавивтуры (правильный)
  puts "\n * Ваш ответ: \n"
  user_answer_char = gets.strip[0]
  if user_answer_char.between?("A", "D") # ответ между A и D
    break
  else
    puts " Введите только A, B, C или D"
  end
end

File.write(
  filename, 
  "Ответ пользователя: #{answers[user_answer_char]}\n\n",
  mode: "a"
  )

# Мы сравниваем ответ с правильным
if answers[user_answer_char] == correct_answer
  puts "\nПравильно!"
  correct_answers += 1

  File.write(
  filename, 
  "Правильно!",
  mode: "a"
  )

else
  puts "\nНеправильно!"
  puts "\nПравильный ответ: #{correct_answer}"
  incorrect_answers += 1

  File.write(
  filename, 
  "Неправильно!\nПравильный ответ: #{correct_answer}",
  mode: "a"
  )
end

end

# Сохраняем результаты пользователя в текстовом файле TXT

File.write(
  filename, 
  "\n\n===РЕЗУЛЬТАТ===\n\n - Правильных ответов: #{correct_answers}\n",
  mode: "a"
  )

File.write(
  filename, 
  " - Неправильных ответов: #{incorrect_answers}\n",
  mode: "a"
  )

correct_answer_percentage = ((correct_answers / all_questions.length.to_f) * 100) # процент правильных ответов

File.write(
    filename, 
    " - Процент правильных ответов: #{correct_answer_percentage.floor(1)}%\n\n",
    mode: "a"
    )  #.floor(2) - округляет до двух знаков после запятой

# Определяем по % правильных ответов, какоё уровень знаний пользователя
if correct_answer_percentage >= 80
  puts "\n*** Ваш уровень сноубордиста - Шон Уайт, спасибо за уделённое время ***"
  File.write(
    filename, 
    "\n*** Ваш уровень сноубордиста - Шон Уайт, спасибо за уделённое время ***",
    mode: "a"
    )
elsif correct_answer_percentage >= 60
  puts "\n*** Ваш уровень сноубордиста - нормальный такой катун ***"
  File.write(
    filename, 
    "\n*** Ваш уровень сноубордиста - нормальный такой катун ***",
    mode: "a"
    )
else
  puts "\n*** Ваш уровень сноубордиста - ходун, а не катун ***"
  File.write(
    filename, 
    "\n*** Ваш уровень сноубордиста - ходун, а не катун ***",
    mode: "a"
    )
end

File.write(
    filename, 
    "\n\n===КОНЕЦ ТЕСТА===\n\n",
    mode: "a"
  )