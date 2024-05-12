
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Не ЗавершениеРаботы = Истина И Модифицированность Тогда

		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Данные были изменены! Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	   
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды  
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ГиперссылкаФайлов = РаботаСФайлами.ГиперссылкаФайлов();
	ГиперссылкаФайлов.Размещение = "Файлы";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	Если Не ЗначениеЗаполнено(Объект.Адресат) Тогда
		Объект.Адресат = "Не использовать";
	КонецЕсли; 
	
	Элементы.ГруппаГруппИспытания.Скрыть();
	Элементы.ГруппаГруппИспытания.Показать();
	
		Объект.Ответственный = Пользователи.ТекущийПользователь();
	
	Если Объект.ИспользоватьPID Тогда
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ВыпускаемаяПродукцияPID.Видимость = Истина;
	Иначе
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ВыпускаемаяПродукцияPID.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьУсловноеОформлениеТабличнойЧасти();
	
	УстановитьВидимостьЭлементовПоРолям();
		
КонецПроцедуры


&НаКлиенте
Асинх Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("Марка") Тогда

		НовСтр = Объект.СписокКабелей.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыбранноеЗначение);
		НовСтр.ВесНетто = Окр(ВыбранноеЗначение.Вес, 0, РежимОкругления.Окр15как20);
		Элементы.СписокКабелей.ТекущаяСтрока = НовСтр.ПолучитьИдентификатор();
		Модифицированность = Истина;

	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство(
		"АдресДанныхДляЗаполнения") Тогда

		Если ВыбранноеЗначение.АдресДанныхДляЗаполнения <> Неопределено И Объект.СписокКабелей.Количество() < 16
		И Объект.СписокКабелей.Количество()+ВыбранноеЗначение.КоличествоСтрокПереноса <=16 Тогда

			ЗаполнитьИзДанныхДляЗаполненияНасервере(ВыбранноеЗначение.АдресДанныхДляЗаполнения);
			
			//ПриСозданииНаСервере(Ложь, Истина);
			
			Модифицированность = Истина;

		Иначе

			Обещание = ВопросАсинх(ТекстВопроса(), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
			Результат = Ждать Обещание;

			Если Результат = КодВозвратаДиалога.Да Тогда

				СсылкаНаДокумент = СоздатьНовыйДокументВыпуск();
				ОткрытьЗначениеАсинх(СсылкаНаДокумент);

			ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда

				Возврат;
			Иначе
			   КонецЕсли;
		КонецЕсли;

	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ДанныеФормыКоллекция") Тогда

		Для Каждого Значение Из ВыбранноеЗначение Цикл

			НоваяСтрокаТабличнойЧасти = Объект.СписокКабелей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, Значение);

		КонецЦикла; 
		   //ТекущаяСтрокаДляВозврата
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство(
		"ТребуемоеЗначениеЖилаОсновная") Тогда

		ТекущиеДанные  = Элементы.СписокКабелей.ТекущиеДанные;
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ВыбранноеЗначение);
		ТекущиеДанные.ПризнакРучныеИзмененияТребуемыхЗначений = Не ВыбранноеЗначение.ОтключитьРучныеИсправления;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// При записи на сервере.
// 
// Параметры:
//  Отказ - Булево - Отказ
//  ТекущийОбъект - ДокументОбъект.ВыпускПродукции - Текущий объект
//  ПараметрыЗаписи - Структура - Параметры записи
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	КоличествоОтмеченныхСтрок = 0;
	
	Для каждого СтрокаТаблицы из Объект.СписокКабелей Цикл   
		
		Если СтрокаТаблицы.ВыгружатьВыделеннуюСтроку Тогда
			КоличествоОтмеченныхСтрок = КоличествоОтмеченныхСтрок+1; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыЗаписи.Свойство("ПараметрыВыполненияПодключаемойКоманды") Тогда
		Если КоличествоОтмеченныхСтрок>1 Тогда
			ПредставлениеКоличества = ПолучитьСклоненияСтрокиПоЧислу( "строка", КоличествоОтмеченныхСтрок);
			Отказ = Истина;
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Ошибка, отмечено:  %1, для вывода на печать, отметьте одну строку", ПредставлениеКоличества[0]);
			ОбщегоНазначения.СообщитьПользователю(Текст,, 
			"Объект.ВыгружатьВыделеннуюСтроку");
			
		ИначеЕсли КоличествоОтмеченныхСтрок=0 и ПараметрыЗаписи.ПараметрыВыполненияПодключаемойКоманды.ОписаниеКоманды.Идентификатор = "СертификатКачества(MSWord)" Тогда  
			Отказ = Истина;
			Текст =  НСтр("ru='Не отмечено ни одной строки, отметьте строку для фомирования сертификата'");
			ОбщегоНазначения.СообщитьПользователю(Текст,, 
			"Объект.ВыгружатьВыделеннуюСтроку");
			
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры 


&НаСервере
Процедура ЗаписатьИсключениеВЖурнал(Комментарий) 
	СобытияДляЖурнала = Новый СписокЗначений;
	СобытиеДляЖурнала =
	Новый Структура("ИмяСобытия, ПредставлениеУровня, Комментарий");
	СобытиеДляЖурнала.ИмяСобытия = "Исключение при печати word";
	СобытиеДляЖурнала.ПредставлениеУровня = "Предупреждение";
	// "Информация", "Ошибка", "Предупреждение", "Примечание"
	СобытиеДляЖурнала.Комментарий = Комментарий;
	СобытияДляЖурнала.Добавить(СобытиеДляЖурнала); 
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурнала);
КонецПроцедуры


&НаКлиенте
Асинх Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)  
	ОчиститьСообщения();
		
		Для Каждого СтрокаТаблицы Из Объект.СписокКабелей Цикл 
			
						
			ЕстьЗапрещенныеСимволы = ЕстьЗапрещенныеСимволы(СтрокаТаблицы.КоличествоСтрокой);
			
			Если ЕстьЗапрещенныеСимволы Тогда
				Отказ = Истина;
				
				ОбщегоНазначенияКлиент.СообщитьПользователю("Строка вычисления длин на барабане, 
				|содержит недопустимые символы(разрешено, только использование знака +), исправьте",, 
				"Объект.ВыпускаемаяПродукция[" + (СтрокаТаблицы.НомерСтроки - 1) + "].КоличествоСтроко");
				
			
			КонецЕсли;
		КонецЦикла;  
		
	
				
							
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьPIDПриИзменении(Элемент)
	Если Объект.ИспользоватьPID Тогда

		Элементы.СписокКабелей.ПодчиненныеЭлементы.ВыпускаемаяПродукцияPID.Видимость = Истина;
		Модифицированность = Истина;
		ЭтаФорма.ОбновитьОтображениеДанных();
	Иначе
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ВыпускаемаяПродукцияPID.Видимость = Ложь;
		Модифицированность = Истина;
		ЭтаФорма.ОбновитьОтображениеДанных();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКабелей

&НаКлиенте
Процедура КоличествоСтрокойПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	Если Не ТекущиеДанные.РучноеРедактированиеКоличествоСтрокой Тогда
		ТекущиеДанные.КоличествоСтрокой = "";
	КонецЕсли;
	ПересчитатьВес(Элементы.СписокКабелей.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ВыгружатьВыделеннуюСтрокуПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	
	Если ТекущиеДанные.ВыгружатьВыделеннуюСтроку  Тогда

		ВключитьИнтерфейсИспытателя(Истина);
		ЭтаФорма.ТекущийЭлемент = Элементы.ВидСертификата;
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ВидСертификата) Тогда
			
			ОтобразитьФормуВыбора(ТекущиеДанные);
			
		КонецЕсли;	
		
	Иначе 
		Элементы.ГруппаГруппИспытания.Скрыть();	
		ТекущиеДанные.ВидСертификата = ОчиститьВидСертификата();
	КонецЕсли; 
		
		
КонецПроцедуры 
&НаСервере
Функция ОчиститьВидСертификата()
	Возврат Перечисления.ВидыСертификатов.ПустаяСсылка();
КонецФункции

&НаКлиенте
Асинх Процедура БухтыПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;

	Если ТекущиеДанные.Тара = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.Тара.Бухта") Тогда

		МассивПодстрок  = 	СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Элемент.ТекстРедактирования,
			"+", Истина, Истина);

		Для Каждого ЭлементМассива Из МассивПодстрок Цикл

			Попытка
				РезультатВычисления = Вычислить(ЭлементМассива);

			Исключение

				Текст = Новый ФорматированнаяСтрока("В строке кабель", Новый ФорматированнаяСтрока(" "
					+ ТекущиеДанные.Марка + " " + ТекущиеДанные.Размер + ", ", , WebЦвета.Зеленый),
					"  поле вычисления строки бухты, проверьте корректность данных,  " + Символы.ПС
					+ "текущее значение: " + Элемент.ТекстРедактирования);
				Обещание = ПредупреждениеАсинх(Текст, , "Ошибка");
				Ждать Обещание;

			КонецПопытки;

		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыпускаемаяПродукцияТараПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	Если ТекущиеДанные.Тара = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.Тара.Бухта") Тогда

		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт.Видимость = Истина;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт.ЦветТекста =WebЦвета.Синий;
		Элементы.СписокКабелей.ТекущийЭлемент = Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт;
		УстановитьУсловноеОформление("РассчитываемоеКоличествоБухт");

	Иначе

		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт.Видимость = Ложь;
		ТекущиеДанные.РассчитываемоеКоличествоБухт = "";

	КонецЕсли;

	ПересчитатьВес(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;

	ПересчитатьВес(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура МаркаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	ТекущиеДанные.Вес = Вес(ТекущиеДанные.Марка);
	ТекущиеДанные.Размер = Размер(ТекущиеДанные.Марка);

	ПересчитатьВес(ТекущиеДанные);      
	
КонецПроцедуры

#КонецОбласти



#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоДругимДокументам(Команда)
	Если Объект.СписокКабелей.Количество() > 0 Тогда

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДругимДокументамЗавершение", ЭтотОбъект),
			"Перед заполнением данные в табличных частях будут очищены. Продолжить заполнение?",
			РежимДиалогаВопрос.ДаНет);

	Иначе

		ОткрытьФормуЗаполнения();
	КонецЕсли;

КонецПроцедуры
   
   // СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
   // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
   
   // СтандартныеПодсистемы.Свойства
   

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено,
	СтандартнаяОбработка = Неопределено)

	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);

КонецПроцедуры
   
   // Конец СтандартныеПодсистемы.Свойства
   
    // СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами
   
   &НаКлиенте
Процедура ВключитьИнтерфейсИспытателя(Команда)
	
	Элементы.ГруппаГруппИспытания.Скрыть();
	Элементы.РучныеИсправленияТребуемыхЗначений.Видимость = Истина;
	Элементы.ГруппаПросмотрИспытаний.Видимость     = Истина;
	Элементы.ПоменятьПанелиМестами.Видимость = Истина;
	Элементы.ГруппаАдресат.Видимость                          = Истина;
	Элементы.ГруппаГруппИспытания.Показать(); 	

КонецПроцедуры
   
   &НаКлиенте
Асинх Процедура УказатьРазмерВручную(Команда)

	Обещание = ВвестиЗначениеАсинх("", "Введите сечения");
	Результат = Ждать Обещание;

	Если Результат = Неопределено Тогда
		Возврат;
	Иначе
		
		ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
		ТекущиеДанные.Размер = Результат;
		ТекущиеДанные.РучноеРедактированиеРазмерКабеляИОтрезок = Истина;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок.Видимость = Истина;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок.ЦветФона =WebЦвета.Синий;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок.ЦветТекста =WebЦвета.Белоснежный;
		Элементы.СписокКабелей.ТекущийЭлемент = Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок;
		УстановитьУсловноеОформление("Отрезок");
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры



&НаКлиенте
Асинх Процедура Подбор(Команда)
	Если Объект.СписокКабелей.Количество() < 16 Тогда

		ОткрытьФорму("Справочник.МаркиКабелей.Форма.ФормаПодбораКабеля", , ЭтотОбъект);
	Иначе

		Обещание = ВопросАсинх(ТекстВопроса(), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		                       Результат = Ждать Обещание;
		Если Результат = КодВозвратаДиалога.Да Тогда
			СсылкаНаДокумент = СоздатьНовыйДокументВыпуск();
			ОткрытьЗначениеАсинх(СсылкаНаДокумент);

		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораМасштабаОтображенияИнтерфейса(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораМасштабаОтображения", , Объект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПанелиМестами(Команда)
	ПоменятьПанелиМестамиНаСервере();
КонецПроцедуры
&НаСервере
Процедура ПоменятьПанелиМестамиНаСервере()

	Элементы.Переместить(Элементы.ГруппаСтраниц, Элементы.ГруппаПеремещенияПанелей);
	
	Элементы.ПоменятьПанелиМестами.Пометка = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоДругимДокументамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда

		Объект.СписокКабелей.Очистить();
		ОткрытьформуЗаполнения();

	КонецЕсли;
КонецПроцедуры

// Открыть форму заполнения.
//Открывает форму СКД для добавления строк выбранных в открывшейся форме в табличную часть документа
//@skip-check module-structure-form-event-regions
&НаКлиенте
Процедура ОткрытьФормуЗаполнения()

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КоличествоСтрокДокумента",Объект.СписокКабелей.Количество());

	   //
	ОткрытьФорму("Документ.ВыпускПродукции.Форма.ФормаЗаполненияСКД", ПараметрыФормы, ЭтаФорма, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры // ОткрытьФормуЗаполнения()

&НаКлиенте
Процедура ДобавитьИзДругихДокументов(Команда)
	ОткрытьФормуЗаполнения();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	Объект.Записать();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВвестиКоличествоСтрокой(Команда)
	Обещание = ВвестиЗначениеАсинх("", "Введите количество длин на барабане");
	Результат = Ждать Обещание;

	Если Результат = Неопределено Тогда
		Возврат;
	Иначе
		ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
		ТекущиеДанные.Количество = 0;
		ТекущиеДанные.КоличествоСтрокой = Результат;
		ТекущиеДанные.РучноеРедактированиеКоличествоСтрокой = Истина;
		Модифицированность = Истина;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаКоличество.ПодчиненныеЭлементы.КоличествоСтрокой.Видимость  = Истина;
		Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаКоличество.ПодчиненныеЭлементы.КоличествоСтрокой.ЦветТекста = WebЦвета.Синий;
		Элементы.СписокКабелей.ТекущийЭлемент = Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаКоличество.ПодчиненныеЭлементы.КоличествоСтрокой;
		УстановитьУсловноеОформление("КоличествоСтрокой");
		ПересчитатьВес(Элементы.СписокКабелей.ТекущиеДанные);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СнятьВсеФлаги(Команда)
	Для каждого СтрокаТЧ из Объект.СписокКабелей Цикл
	  СтрокаТЧ.ВыгружатьВыделеннуюСтроку = Ложь;
	  СтрокаТЧ.ВидСертификата = ОчиститьВидСертификата();
	КонецЦикла;
	
КонецПроцедуры
   // Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЕстьЗапрещенныеСимволы(СтрокаПоиска)

	СимволыПоиска = "*-=\/<>^&$#!~`'()?:;~абвгдеёжзийклмнопрстуфхцчшщьъюэя";
	МассивСтрок = СтрРазделить(СтрокаПоиска, СимволыПоиска, Истина);

	Если МассивСтрок.Количество() > 1 Тогда
		ЕстьЗапрещенныеСимволы =  Истина;
	Иначе
		ЕстьЗапрещенныеСимволы =  Ложь;
	КонецЕсли;

	Возврат ЕстьЗапрещенныеСимволы;

КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере();
	Иначе
		Модифицированность =Ложь;

	КонецЕсли;

	Закрыть();
КонецПроцедуры

&НаСервере
Функция Вес(Марка)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Марка, "Вес");

КонецФункции

&НаСервере
Функция Размер(Марка)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Марка, "Размер");

КонецФункции


&НаКлиенте
Функция ТекстВопроса()

	Возврат НСтр("ru='Более 16 позиций кабеля в одном документе не предусмотрено, 
	|создать новый документ?'");

КонецФункции

// Заполнить из данных для заполнения насервере.
// Заполняет форму новыми данны полученными из выбранного в диалоге документа
// Параметры:
//  АдресДанных  - ХранилищеЗначения
&НаСервере
Процедура ЗаполнитьИзДанныхДляЗаполненияНасервере(АдресДанных)

	ТаблицаЗначений  = ПолучитьИзВременногоХранилища(АдресДанных);
	
	
	
	Для Каждого СтрокаТЧ Из ТаблицаЗначений Цикл
		
		НоваяСтрокаТЧ =  Объект[СтрокаТЧ.ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтрокаТЧ);
		УстановитьУсловноеОформлениеТабличнойЧасти();
	КонецЦикла; 
	
	
КонецПроцедуры // ЗаполнитьИзДанныхДляЗаполненияНаСервере()  


&НаСервере
Процедура УстановитьУсловноеОформлениеТабличнойЧасти() 
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокКабелей Цикл
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.РассчитываемоеКоличествоБухт) И СтрокаТабличнойЧасти.Тара
			= ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Тара.Бухта") Тогда
			
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт.Видимость = Истина;
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.РассчитываемоеКоличествоБухт.ЦветТекста = WebЦвета.Синий;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Отрезок) И СтрокаТабличнойЧасти.РучноеРедактированиеРазмерКабеляИОтрезок Тогда
			
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок.Видимость = Истина;
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаТара.ПодчиненныеЭлементы.Отрезок.ЦветТекста  = WebЦвета.Синий;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.КоличествоСтрокой) И СтрокаТабличнойЧасти.РучноеРедактированиеКоличествоСтрокой Тогда
			
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаКоличество.ПодчиненныеЭлементы.КоличествоСтрокой.Видимость = Истина;
			Элементы.СписокКабелей.ПодчиненныеЭлементы.ГруппаКоличество.ПодчиненныеЭлементы.КоличествоСтрокой.ЦветТекста  = WebЦвета.Синий;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры 

Процедура УстановитьВидимостьЭлементовПоРолям()  
	
	Если Пользователи.РолиДоступны("АдминистраторСистемы",  Пользователи.ТекущийПользователь(), Ложь) Тогда
		Элементы.ВвестиКоличествоСтрокой.Видимость = Истина;
		Элементы.Подбор.Доступность                = Истина;
		Элементы.УказатьРазмерВручную.Видимость    = Истина;
		Элементы.ГруппаЗаполнить.Доступность       = Истина;
		Элементы.КопироватьВБуферОбмена.Видимость  = Истина;
		Элементы.ВыделитьВсе.Видимость             = Истина;
		Элементы.Скопировать.Видимость             = Истина;
		Элементы.ГруппаАдресат.Видимость           = Истина;
		Элементы.ИспользоватьPID.Видимость         = Истина;
		Элементы.ГруппаПросмотрИспытаний.Видимость = Истина;  
		Элементы.ВыбораМасштабаОтображенияИнтерфейса.Видимость = Ложь;
		Элементы.ГруппаГруппИспытания.Скрыть();
		
	ИначеЕсли Пользователи.РолиДоступны("ИспытательКабеля",  Пользователи.ТекущийПользователь(), Ложь) Тогда
		
		Элементы.ВвестиКоличествоСтрокой.Видимость = Ложь;
		Элементы.Подбор.Доступность                = Ложь;
		Элементы.УказатьРазмерВручную.Видимость    = Ложь;
		Элементы.ГруппаЗаполнить.Доступность       = Ложь;
		Элементы.КопироватьВБуферОбмена.Видимость  = Ложь;
		Элементы.ВыделитьВсе.Видимость             = Ложь;
		Элементы.Скопировать.Видимость             = Ложь;
		Элементы.ГруппаАдресат.Видимость           = Ложь;
		Элементы.ИспользоватьPID.Видимость         = Ложь;
		Элементы.ГруппаЗаполнить.Видимость         = Ложь;
		Элементы.Подбор.Видимость                  = Ложь;
		//Элементы.ПодменюПечать.Видимость            = Ложь;  Изменено после рефакторинга
		Элементы.Изменить.Видимость                = Ложь;
		Элементы.Переместить(Элементы.ГруппаНомерДата, Элементы.ГруппаПеремещения);
		Элементы.ГруппаГруппИспытания.Скрыть();
		
	ИначеЕсли Пользователи.РолиДоступны("РаботаСКабелем",  Пользователи.ТекущийПользователь(), Ложь) Тогда
		
		Элементы.РучныеИсправленияТребуемыхЗначений.Видимость = Ложь;
		Элементы.ГруппаПросмотрИспытаний.Видимость     = Ложь;
		Элементы.ПоменятьПанелиМестами.Видимость = Ложь;
		Элементы.ГруппаАдресат.Видимость                          = Истина;
		Элементы.ВыбораМасштабаОтображенияИнтерфейса.Видимость = Ложь; 
		Элементы.ГруппаГруппИспытания.Скрыть();
		
	КонецЕсли;   

	
КонецПроцедуры

&НаСервере
Функция СоздатьНовыйДокументВыпуск()

	НовыйДокумент = Документы.ВыпускПродукции.СоздатьДокумент();

	НовыйДокумент.Дата = ТекущаяДатаСеанса();
	НовыйДокумент.Записать();

	Возврат НовыйДокумент.Ссылка;

КонецФункции 


&НаСервере
Процедура УстановитьУсловноеОформление(Поле)
	ОбщегоНазначенияУсловноеОформление.УстановитьУсловноеоформлениеФормы(ЭтотОбъект, Поле);
КонецПроцедуры

&НаСервере
Функция ВесТары(Тара)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Тара, "ВесТары");

КонецФункции

&НаКлиенте
Асинх Процедура ПересчитатьВес(ТекущиеДанные)
	Если ТекущиеДанные.Тара = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.Тара.Бухта") Тогда

		ТекущиеДанные.ВесНетто =0;

	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.КоличествоСтрокой) Тогда

		Итого = 0;
		МассивПодстрок  = 	СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
	
			ТекущиеДанные.КоличествоСтрокой, "+", Истина, Истина);

		Для Каждого ЭлементМассива Из МассивПодстрок Цикл

			ТолькоЦифрыВСтроке =    Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЭлементМассива);

			Если ТолькоЦифрыВСтроке Тогда

				МассивЧисел = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементМассива, "+", Истина, Истина);

				Если МассивЧисел <> Неопределено Тогда

					Если МассивЧисел.Количество() = 1 Тогда

						ЕстьЗапрещенныеСимволы = ЕстьЗапрещенныеСимволы(ТекущиеДанные.КоличествоСтрокой);
						
						Если ЕстьЗапрещенныеСимволы <> Неопределено И ЕстьЗапрещенныеСимволы Тогда

							Ждать  ПредупреждениеАсинх("Строка вычисления длин на барабане, содержит недопустимые символы. исправьте",, "Внимание!");

						Иначе

							Попытка

								ЧислоИзСтроки ="" + СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ЭлементМассива) * 1000;
								Итого = Итого + ЧислоИзСтроки;

							Исключение

								Инфо = ИнформацияОбОшибке();
								ОбработкаОшибок.ПоказатьИнформациюОбОшибке(Инфо);
							КонецПопытки;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

		Если Итого <> 0 Тогда
			ТекущиеДанные.Количество = Итого / 1000;
		КонецЕсли;

		ТекущиеДанные.ВесНетто = Окр(ТекущиеДанные.Вес, 0, РежимОкругления.Окр15как20) * ТекущиеДанные.Количество;
		Если ЗначениеЗаполнено(ТекущиеДанные.Тара) И ЗначениеЗаполнено(ТекущиеДанные.Количество) И ЗначениеЗаполнено(
			ТекущиеДанные.ВесНетто) Тогда
			ТекущиеДанные.ВесБрутто = ТекущиеДанные.ВесНетто + ?(ВесТары(ТекущиеДанные.Тара) <> Неопределено,
				ВесТары(ТекущиеДанные.Тара), 1);
		КонецЕсли;

	Иначе
		ТекущиеДанные.ВесНетто = Окр(ТекущиеДанные.Вес, 0, РежимОкругления.Окр15как20) * ТекущиеДанные.Количество;
		Если ЗначениеЗаполнено(ТекущиеДанные.Тара) И ЗначениеЗаполнено(ТекущиеДанные.Количество) И ЗначениеЗаполнено(
			ТекущиеДанные.ВесНетто) Тогда
			ТекущиеДанные.ВесБрутто = ТекущиеДанные.ВесНетто + ?(ВесТары(ТекущиеДанные.Тара) <> Неопределено,
				ВесТары(ТекущиеДанные.Тара), 1);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОтобразитьФормуВыбора(ТекущиеДанные) Экспорт
   
    Оповещение = Новый ОписаниеОповещения("ВыборЗавершен",
     ЭтотОбъект,ТекущиеДанные);
               
    ОткрытьФорму("Перечисление.ВидыСертификатов.ФормаВыбора",
        ,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗавершен(Результат, ПараметрыКонтекста) Экспорт

    Если ЗначениеЗаполнено(Результат) Тогда
		ПараметрыКонтекста.ВидСертификата = Результат; 
		Если  Результат = ПредопределенноеЗначение("Перечисление.ВидыСертификатов.АС_839_2019") Тогда 
			  УстановитьВидимостьЭлементовИспытания(Ложь, Ложь);
		  Иначе
			  УстановитьВидимостьЭлементовИспытания(Истина, Истина);


		КонецЕсли;
	Иначе
	    ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Значение  сертификата не выбрано'"));
    КонецЕсли;

КонецПроцедуры 

Процедура УстановитьВидимостьЭлементовИспытания(Видимость, НетИзоляции);
	
	Элементы.РезультатИспытанияОсновнаяЖилаКоричневая.Видимость = Видимость;
	Элементы.РезультатИспытанияОсновнаяЖилаЧерная.Видимость     = Видимость;
	Элементы.РезультатИспытанияЖилаСиняя.Видимость              = Видимость;
	Элементы.РезультатИспытанияЖилаЗаземления.Видимость         = Видимость;
	Если   НЕ НетИзоляции Тогда
		Элементы.РезультатИспытанияИзоляцииЖилаОсновная.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаКоричневая.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаСиняя.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаЧерная.Видимость = Видимость; 
		Элементы.РезультатИспытанияИзоляцииЖилаЗаземления.Видимость = Видимость;  
	Иначе
		Элементы.РезультатИспытанияИзоляцииЖилаОсновная.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаКоричневая.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаСиняя.Видимость = Видимость;
		Элементы.РезультатИспытанияИзоляцииЖилаЧерная.Видимость = Видимость; 
		Элементы.РезультатИспытанияИзоляцииЖилаЗаземления.Видимость = Видимость; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура РучныеИсправленияТребуемыхЗначений(Команда)
		ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	Имя = "Документ.ВыпускПродукции.Форма.ВводИсправленийТребуемыхЗначений";
	РезультатыИспытаний = Новый Структура;

	РезультатыИспытаний.Вставить("ТребуемоеЗначениеИспытанияЖилы", ТекущиеДанные.ТребуемоеЗначениеЖилаОсновная);
	РезультатыИспытаний.Вставить("ТребуемоеЗначениеИпытанияИзоляции",
		ТекущиеДанные.ТребуемоеЗначениеИзоляцииЖилаОсновная);
	ПараметрыПодбора = РезультатыИспытаний;
	
	ОткрытьФорму(Имя, ПараметрыПодбора, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	Оповестить("ЗаписьВыпускПродукции", Новый Структура, Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект) 
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВидСертификатаПриИзменении(Элемент)
         ТекущиеДанные = Элементы.СписокКабелей.ТекущиеДанные;
	Если  ТекущиеДанные.ВидСертификата = ПредопределенноеЗначение("Перечисление.ВидыСертификатов.АС_839_2019") Тогда 
		УстановитьВидимостьЭлементовИспытания(Ложь, Истина);
	Иначе
		УстановитьВидимостьЭлементовИспытания(Истина, Ложь);
		
		
	КонецЕсли;

КонецПроцедуры
 
#КонецОбласти







