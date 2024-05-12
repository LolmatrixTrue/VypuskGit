///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДополнительныеДанные = Параметры.ДополнительныеДанные;
	
	Если ЗначениеЗаполнено(Параметры.ИнформацияДляПоддержки) Тогда
		Элементы.ИнформацияДляПоддержки.Заголовок = Параметры.ИнформацияДляПоддержки;
	Иначе
		Элементы.ИнформацияДляПоддержки.Заголовок = ЭлектроннаяПодписьСлужебный.ЗаголовокИнформацииДляПоддержки();
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.УстановитьЗаголовокОшибки(ЭтотОбъект,
		Параметры.ЗаголовокПредупреждения);
	
	ТекстОшибкиКлиент = Параметры.ТекстОшибкиКлиент;
	ТекстОшибкиСервер = Параметры.ТекстОшибкиСервер;
	ТекстОшибки = Параметры.ТекстОшибки;
	
	ДвеОшибки = Не ПустаяСтрока(ТекстОшибкиКлиент)
		И Не ПустаяСтрока(ТекстОшибкиСервер);
	
	УстановитьЭлементы(ТекстОшибкиКлиент, ДвеОшибки, "Клиент");
	УстановитьЭлементы(ТекстОшибкиСервер, ДвеОшибки, "Сервер");
	УстановитьЭлементы(ТекстОшибки, ДвеОшибки, "");
	
	Элементы.ДекорацияРазделитель.Видимость = ДвеОшибки;
	
	Если ДвеОшибки
	   И ПустаяСтрока(ЯкорьОшибкиКлиент)
	   И ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
		
		Элементы.ИнструкцияКлиент.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаПодвал.Видимость = Параметры.ПоказатьТребуетсяПомощь;
	Элементы.ДекорацияРазделитель2.Видимость = Параметры.ПоказатьТребуетсяПомощь;
	
	ВидимостьСсылкиНаИнструкцию =
		ЭлектроннаяПодписьСлужебный.ВидимостьСсылкиНаИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	
	Если Параметры.ПоказатьТребуетсяПомощь Тогда
		Элементы.Помощь.Видимость                     = Параметры.ПоказатьИнструкцию;
		Элементы.ФормаПерейтиКНастройкеПрограмм.Видимость = Параметры.ПоказатьПереходКНастройкеПрограмм;
		Элементы.ФормаУстановитьРасширение.Видимость      = Параметры.ПоказатьУстановкуРасширения;
		Элементы.ИнструкцияКлиент.Видимость = Элементы.ИнструкцияКлиент.Видимость И ВидимостьСсылкиНаИнструкцию 
			И ЗначениеЗаполнено(ЯкорьОшибкиКлиент);
		Элементы.ИнструкцияСервер.Видимость = ВидимостьСсылкиНаИнструкцию И ЗначениеЗаполнено(ЯкорьОшибкиСервер);
		ОписаниеОшибки = Параметры.ОписаниеОшибки;
	Иначе
		Элементы.ИнструкцияКлиент.Видимость = Элементы.ИнструкцияКлиент.Видимость И ВидимостьСсылкиНаИнструкцию;
		Элементы.ИнструкцияСервер.Видимость = ВидимостьСсылкиНаИнструкцию;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЯкорьОшибки = "";
	Если Элемент.Имя = "ИнструкцияКлиент"
		И Не ПустаяСтрока(ЯкорьОшибкиКлиент) Тогда
		
		ЯкорьОшибки = ЯкорьОшибкиКлиент;
	ИначеЕсли Элемент.Имя = "ИнструкцияСервер"
		И Не ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
		
		ЯкорьОшибки = ЯкорьОшибкиСервер;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами(ЯкорьОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияДляПоддержкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "ТипичныеПроблемы" Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	Иначе
	
		ТекстОшибок = "";
		ОписаниеФайлов = Новый Массив;
		Если ЗначениеЗаполнено(ДополнительныеДанные) Тогда
			ЭлектроннаяПодписьСлужебныйВызовСервера.ДобавитьОписаниеДополнительныхДанных(
				ДополнительныеДанные, ОписаниеФайлов, ТекстОшибок);
		КонецЕсли;
		
		ТекстОшибок = ТекстОшибок + ОписаниеОшибки;
		ЭлектроннаяПодписьСлужебныйКлиент.СформироватьТехническуюИнформацию(ТекстОшибок, , ОписаниеФайлов);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПричиныКлиентТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура РешенияКлиентТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура ПричиныСерверТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

&НаКлиенте
Процедура РешенияСерверТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеДанные());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройкеПрограмм(Команда)
	
	Закрыть();
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Программы");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьРасширение(Истина);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЭлементы(ТекстОшибки, ДвеОшибки, МестоОшибки)
	
	Если МестоОшибки = "Сервер" Тогда
		ЭлементОшибка = Элементы.ОшибкаСервер;
		ЭлементТекстОшибки = Элементы.ТекстОшибкиСервер;
		ЭлементИнструкция = Элементы.ИнструкцияСервер;
		ЭлементПричиныТекст = Элементы.ПричиныСерверТекст;
		ЭлементРешенияТекст = Элементы.РешенияСерверТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияСервер;
	ИначеЕсли МестоОшибки = "Клиент" Тогда
		ЭлементОшибка = Элементы.ОшибкаКлиент;
		ЭлементТекстОшибки = Элементы.ТекстОшибкиКлиент;
		ЭлементИнструкция = Элементы.ИнструкцияКлиент;
		ЭлементПричиныТекст = Элементы.ПричиныКлиентТекст;
		ЭлементРешенияТекст = Элементы.РешенияКлиентТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияКлиент;
	Иначе
		ЭлементОшибка = Элементы.Ошибка;
		ЭлементТекстОшибки = Элементы.ТекстОшибки;
		ЭлементИнструкция = Элементы.Инструкция;
		ЭлементПричиныТекст = Элементы.ПричиныТекст;
		ЭлементРешенияТекст = Элементы.РешенияТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешения;
	КонецЕсли;
	
	ЭлементОшибка.Видимость = Не ПустаяСтрока(ТекстОшибки);
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		
		ЕстьПричинаИРешение = Неопределено;
		Если ТипЗнч(ДополнительныеДанные) = Тип("Структура") Тогда
			Если МестоОшибки = "Сервер" Тогда
				СуффиксПроверок = "НаСервере";
			ИначеЕсли МестоОшибки = "Клиент" Тогда
				СуффиксПроверок = "НаКлиенте";
			Иначе
				СуффиксПроверок = "";
			КонецЕсли;
				
			ЕстьПричинаИРешение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, 
				"ДополнительныеДанныеПроверок" + СуффиксПроверок, Неопределено); // см. ЭлектроннаяПодписьСлужебныйКлиентСервер.ПредупреждениеПриПроверкеУдостоверяющегоЦентраСертификата
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЕстьПричинаИРешение) Тогда
			ОшибкаПоКлассификатору = ЭлектроннаяПодписьСлужебный.ПредставлениеОшибки();
			Причина = ЕстьПричинаИРешение.Причина; // Строка
			ОшибкаПоКлассификатору.Причина = ФорматированнаяСтрока(Причина);
			ОшибкаПоКлассификатору.Решение = ФорматированнаяСтрока(ЕстьПричинаИРешение.Решение);
		Иначе
			ОшибкаПоКлассификатору = ЭлектроннаяПодписьСлужебный.ОшибкаПоКлассификатору(ТекстОшибки, МестоОшибки = "Сервер");
		КонецЕсли;
		
		ЭтоИзвестнаяОшибка = ОшибкаПоКлассификатору <> Неопределено;
		
		ГруппаПричиныИРешения.Видимость = ЭтоИзвестнаяОшибка;
		Если ЭтоИзвестнаяОшибка Тогда
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.ДействияДляУстранения) Тогда
				Если ОшибкаПоКлассификатору.ДействияДляУстранения.Найти(
					"УказатьВРешенииСсылкуНаУдостоверяющийЦентр") <> Неопределено Тогда
					ИздательСертификата = ИздательСертификата();
					Если ЗначениеЗаполнено(ИздательСертификата) Тогда
						Решение = Новый Массив;
						Решение.Добавить(ОшибкаПоКлассификатору.Решение);
						Решение.Добавить(Символы.ПС);
						Решение.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Удостоверяющий центр, выдавший сертификат: %1.'"), ИздательСертификата));
						ОшибкаПоКлассификатору.Решение = Новый ФорматированнаяСтрока(Решение);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементИнструкция.Имя, "Заголовок", НСтр("ru = 'Подробнее'"));
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.Причина) Тогда
				Если ТипЗнч(ЭлементПричиныТекст) = Тип("ДекорацияФормы") Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементПричиныТекст.Имя, "Заголовок", ОшибкаПоКлассификатору.Причина);
				Иначе
					ЭтотОбъект[ЭлементПричиныТекст.ПутьКДанным] = ОшибкаПоКлассификатору.Причина;
				КонецЕсли;
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементПричиныТекст.Имя, "Видимость", Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОшибкаПоКлассификатору.Решение) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементРешенияТекст.Имя, "Заголовок", ОшибкаПоКлассификатору.Решение);
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
					ЭлементРешенияТекст.Имя, "Видимость", Ложь);
			КонецЕсли;
			
			Если МестоОшибки = "Сервер" Тогда
				ЯкорьОшибкиСервер = ОшибкаПоКлассификатору.Ссылка;
			ИначеЕсли МестоОшибки = "Клиент" Тогда
				ЯкорьОшибкиКлиент = ОшибкаПоКлассификатору.Ссылка;
			Иначе
				ЯкорьОшибки = ОшибкаПоКлассификатору.Ссылка;
			КонецЕсли;
			
		КонецЕсли;
		
		ТребуемоеКоличествоСтрок = 0;
		ШиринаПоля = Цел(?(Ширина < 20, 20, Ширина) * 1.4);
		Для НомерСтроки = 1 По СтрЧислоСтрок(ТекстОшибки) Цикл
			ТребуемоеКоличествоСтрок = ТребуемоеКоличествоСтрок + 1
				+ Цел(СтрДлина(СтрПолучитьСтроку(ТекстОшибки, НомерСтроки)) / ШиринаПоля);
		КонецЦикла;
		Если ТребуемоеКоличествоСтрок > 5 И Не ДвеОшибки Тогда
			ЭлементТекстОшибки.Высота = 4;
		ИначеЕсли ТребуемоеКоличествоСтрок > 3 Тогда
			ЭлементТекстОшибки.Высота = 3;
		ИначеЕсли ТребуемоеКоличествоСтрок > 1 Тогда
			ЭлементТекстОшибки.Высота = 2;
		Иначе
			ЭлементТекстОшибки.Высота = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИздательСертификата()
	
	Если Не ЗначениеЗаполнено(ДополнительныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеСертификата = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "ДанныеСертификата", Неопределено);
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		Если ТипЗнч(ДанныеСертификата) = Тип("Строка") Тогда
			ДанныеСертификата = ПолучитьИзВременногоХранилища(ДанныеСертификата);
		КонецЕсли;
	Иначе
		Сертификат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "Сертификат", Неопределено);
		Если ЗначениеЗаполнено(Сертификат) Тогда
			Если ТипЗнч(Сертификат) = Тип("Массив") Тогда
				Если Сертификат.Количество() > 0 Тогда
					Если ТипЗнч(Сертификат[0]) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
						ДанныеСертификата = ДанныеСертификата(Сертификат[0], Неопределено);
					Иначе
						ДанныеСертификата = ПолучитьИзВременногоХранилища(Сертификат[0]);
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
				ДанныеСертификата = ДанныеСертификата(Сертификат, Неопределено);
			ИначеЕсли ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
				ДанныеСертификата = Сертификат;
			Иначе
				ДанныеСертификата = ПолучитьИзВременногоХранилища(Сертификат);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		СвойстваИздателя = ЭлектроннаяПодпись.СвойстваИздателяСертификата(Новый СертификатКриптографии(ДанныеСертификата));
		Возврат СвойстваИздателя.ОбщееИмя;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция ДополнительныеДанные()
	
	Если Не ЗначениеЗаполнено(ДополнительныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДополнительныеДанныеДляКлассификатораОшибок = ЭлектроннаяПодписьСлужебныйКлиент.ДополнительныеДанныеДляКлассификатораОшибок();
	Сертификат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "Сертификат", Неопределено);
	Если ЗначениеЗаполнено(Сертификат) Тогда
		Если ТипЗнч(Сертификат) = Тип("Массив") Тогда
			Если Сертификат.Количество() > 0 Тогда
				Если ТипЗнч(Сертификат[0]) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
					ДополнительныеДанныеДляКлассификатораОшибок.Сертификат = Сертификат[0];
					ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата(Сертификат[0], УникальныйИдентификатор);
				Иначе
					ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = Сертификат[0];
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
			ДополнительныеДанныеДляКлассификатораОшибок.Сертификат = Сертификат;
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата(Сертификат, УникальныйИдентификатор);
		ИначеЕсли ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ПоместитьВоВременноеХранилище(Сертификат, УникальныйИдентификатор);
		Иначе
			ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = Сертификат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеСертификата = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеДанные, "ДанныеСертификата", Неопределено);
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		ДополнительныеДанныеДляКлассификатораОшибок.ДанныеСертификата = ДанныеСертификата;
	КонецЕсли;
	
	Возврат ДополнительныеДанныеДляКлассификатораОшибок;

КонецФункции

&НаСервере
Функция ФорматированнаяСтрока(Знач Строка)
	
	Если ТипЗнч(Строка) = Тип("Строка") Тогда
		Строка = СтроковыеФункции.ФорматированнаяСтрока(Строка);
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеСертификата(Сертификат, УникальныйИдентификатор)
	
	ДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "ДанныеСертификата").Получить();
	Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
		Если ЗначениеЗаполнено(УникальныйИдентификатор) Тогда
			Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
		Иначе
			Возврат ДанныеСертификата;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
