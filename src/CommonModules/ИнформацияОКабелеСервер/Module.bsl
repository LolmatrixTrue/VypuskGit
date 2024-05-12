#Область СлужебныеПроцедурыИФункции	
// Получить информацию.
// получает   сечение и размер из полученной строки
// Параметры:
//  СтруктураТекДанных  - Структура - текущие данные строки см. ФормированиеСтруктурыТекущихДанных
// 
// Возвращаемое значение:
//  Структура -  Структура - Получить информацию:
// * КоличествоЖил - Число
// * СечениеЖилы - Число
Функция ИнформацияОКабеле(СтруктураТекДанных) Экспорт  
		ДанныеКабеля = Новый Структура();
		РазделенныйМассив = СтрРазделить(СтруктураТекДанных.Размер, "х");
		
		Если   РазделенныйМассив.Количество() > 1 Тогда
			
			//TODO  Добавить в справочник кабели количество жил, размер и автозаполнение из наименования
			КоличествоЖилСтрокой = РазделенныйМассив[0];	
			КоличествоЖил = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КоличествоЖилСтрокой);
			
			Если КоличествоЖил <>Неопределено Тогда 
			ДанныеКабеля.Вставить("КоличествоЖил",КоличествоЖил);
			КонецЕсли;
			СечениеЖилы = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Лев(СОКРЛП(РазделенныйМассив[1]), 3));
			
			Если СечениеЖилы <>Неопределено Тогда 
							
				ДанныеКабеля.Вставить("СечениеЖилы",СечениеЖилы);
							
			Иначе  
				СечениеЖилыИзСоставаСтроки = ДанныеСоставнойСтроки(РазделенныйМассив[1])[0];
				
				ДанныеКабеля.Вставить("СечениеЖилы",СечениеЖилыИзСоставаСтроки);
				
			КонецЕсли; 
			
		КонецЕсли;  
		
		//@skip-check constructor-function-return-section
		Возврат ДанныеКабеля;

КонецФункции  

 Функция ДанныеСоставнойСтроки(Строка)   
	 
	 МассивЧисел = Новый Массив; 
	 
	 СтрокаЧисел = "";
	 
	 Для Индекс = 1 По СтрДлина(Строка) Цикл
		 
		 Символ = Сред(Строка, Индекс, 1); 
		 
		 Если КодСимвола(Символ) >= 48 И КодСимвола(Символ) <= 57 Тогда 
			 СтрокаЧисел = СтрокаЧисел + Символ;
		 ИначеЕсли СтрДлина(СтрокаЧисел) > 0 Тогда
			 МассивЧисел.Добавить(Число(СтрокаЧисел));
			 СтрокаЧисел = "";
		 КонецЕсли;
		 
	 КонецЦикла;
	 
	 Возврат МассивЧисел
	 
 КонецФункции  
 #КонецОбласти
