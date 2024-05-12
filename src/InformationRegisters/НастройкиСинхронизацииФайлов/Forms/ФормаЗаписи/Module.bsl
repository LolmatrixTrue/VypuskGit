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
	
	Если ЗначениеЗаполнено(Параметры.ВладелецФайла) Тогда
		Запись.ВладелецФайла = Параметры.ВладелецФайла;
		Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
			ИнициализироватьКомпоновщик();
		КонецЕсли;
	КонецЕсли;
	
	Если МассивРеквизитовСТипомДата.Количество() = 0 Тогда
		Элементы.ДобавитьУсловиеПоДате.Доступность = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТипВладельцаФайла) Тогда
		Запись.ТипВладельцаФайла = Параметры.ТипВладельцаФайла;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоФайл") Тогда
		Запись.ЭтоФайл = Параметры.ЭтоФайл;
	КонецЕсли;
	
	Если Параметры.Свойство("НоваяНастройка") Тогда
		НоваяНастройка = Параметры.НоваяНастройка;
	КонецЕсли;
	
	Если Запись.ВладелецФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.УчетнаяЗапись) Тогда
		ЗаполнитьУчетнуюЗаписьСинхронизации();
	КонецЕсли;
	
	ВладелецФайлаНеИдентификаторОбъектовМетаданных = ТипЗнч(Запись.ВладелецФайла) <> Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных");
	Если ВладелецФайлаНеИдентификаторОбъектовМетаданных Тогда
		
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
		ОбъектСинхронизации = "ТолькоФайлыЭлемента";
		
		ИдентификаторВладельцаФайлов = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
		ПредставлениеТипВФ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ТипВладельцаФайла, "Наименование");
		ПредставлениеВладельцаДляЗаголовка = ОбщегоНазначения.ПредметСтрокой(Запись.ВладелецФайла);
		ЭлементСправочника = Запись.ВладелецФайла;
		
		СписокСуществующихНастроек.ЗагрузитьЗначения(СуществующиеОбъектыСинхронизации(ТипЗнч(Запись.ВладелецФайла)));
		
	Иначе
		
		СвойстваВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.ВладелецФайла, 
			"Наименование,ЗначениеПустойСсылки");
		СписокСуществующихНастроек.ЗагрузитьЗначения(СуществующиеОбъектыСинхронизации(ТипЗнч(СвойстваВладельца.ЗначениеПустойСсылки)));
		ОбъектСинхронизации = "ВсеФайлы";
		
		ИдентификаторВладельцаФайлов = Запись.ВладелецФайла;
		ПредставлениеТипВФ = СвойстваВладельца.Наименование;
		ПредставлениеВладельцаДляЗаголовка = ПредставлениеТипВФ;
		ЭлементСправочника = СвойстваВладельца.ЗначениеПустойСсылки;
		
	КонецЕсли;
	
	Если ЕстьНастройкаПравиламСинхронизации(Запись.ВладелецФайла) 
		И (НоваяНастройка ИЛИ ТипЗнч(Запись.ВладелецФайла) <> Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных")) Тогда
		Элементы.ОбъектСинхронизацииВсеФайлы.ТолькоПросмотр = Истина;
		Элементы.ПравилоСинхронизацииГруппа.ТолькоПросмотр  = Истина;
		ОбъектСинхронизации                                 = "ТолькоФайлыЭлемента";
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Настройка синхронизации файлов:'") + " " + ПредставлениеВладельцаДляЗаголовка;
	
	Элементы.ПравилоНастройкиОтбор.РасширеннаяПодсказка.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ПравилоНастройкиОтбор.РасширеннаяПодсказка.Заголовок, ПредставлениеТипВФ);
	Элементы.ОбъектСинхронизацииВсеФайлы.СписокВыбора[0].Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбъектСинхронизацииВсеФайлы.СписокВыбора[0].Представление, ПредставлениеТипВФ);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ПравилоНастройкиОтбор.Шапка = Ложь;
		Элементы.Наименование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ПравилоНастройкиОтборГруппаКолонокПрименение.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.УчетнаяЗапись.ТолькоПросмотр = Параметры.ЗапрещатьИзменятьУчетнуюЗапись;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ВладелецФайла) Тогда
		ИнициализироватьКомпоновщик();
	КонецЕсли;
	Если ТекущийОбъект.ПравилоОтбора.Получить() <> Неопределено Тогда
		Правило.ЗагрузитьНастройки(ТекущийОбъект.ПравилоОтбора.Получить());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" И Не ЗначениеЗаполнено(ЭлементСправочника) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнен объект с присоединенными файлами.'"),
			,
			"ЭлементСправочника");
	КонецЕсли;
		
	Запись.ВладелецФайла = 
		?(ОбъектСинхронизации = "ВсеФайлы", ИдентификаторВладельцаФайлов, ЭлементСправочника);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПравилоОтбора = Правило.ПолучитьНастройки();
	
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" Тогда
		ПравилоОтбора.Отбор.Элементы.Очистить();
		ТекущийОбъект.Наименование = "";
	КонецЕсли;
	
	ТекущийОбъект.ПравилоОтбора = Новый ХранилищеЗначения(ПравилоОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВозвращаемоеЗначение = Новый Структура;
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" Тогда
		СинонимНаименованияОбъекта = ТекущийОбъект.ВладелецФайла;
		ЕстьПравилоОтбора = Ложь;
	Иначе
		СинонимНаименованияОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИдентификаторВладельцаФайлов, "Синоним");
		ЕстьПравилоОтбора = Правило.ПолучитьНастройки().Отбор.Элементы.Количество() > 0;
	КонецЕсли;
	ВозвращаемоеЗначение.Вставить("СинонимНаименованияОбъекта", СинонимНаименованияОбъекта);
	ВозвращаемоеЗначение.Вставить("НоваяНастройка",    НоваяНастройка);
	ВозвращаемоеЗначение.Вставить("ВладелецФайла",     ТекущийОбъект.ВладелецФайла);
	ВозвращаемоеЗначение.Вставить("ТипВладельцаФайла", ТекущийОбъект.ТипВладельцаФайла);
	ВозвращаемоеЗначение.Вставить("Синхронизировать",  ТекущийОбъект.Синхронизировать);
	ВозвращаемоеЗначение.Вставить("Наименование",      ТекущийОбъект.Наименование);
	ВозвращаемоеЗначение.Вставить("УчетнаяЗапись",     ТекущийОбъект.УчетнаяЗапись);
	ВозвращаемоеЗначение.Вставить("ЭтоФайл",           ТекущийОбъект.ЭтоФайл);
	ВозвращаемоеЗначение.Вставить("Правило",           ТекущийОбъект.ПравилоОтбора);
	ВозвращаемоеЗначение.Вставить("ЕстьПравилоОтбора", ЕстьПравилоОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ДобавлениеУсловияПоДате" Тогда
		ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСинхронизацииПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	Запись.ВладелецФайла = ИдентификаторВладельцаФайлов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСинхронизацииФайлыЭлементаПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщик()
	
	Если Не ЗначениеЗаполнено(Запись.ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Правило.Настройки.Отбор.Элементы.Очистить();
	
	СКД = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СКД.ПоляИтога.Очистить();
	
	СКД.НаборыДанных[0].Запрос = ПолучитьТекстЗапроса();
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	Правило.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Правило.Восстановить(); 
	Правило.Настройки.Структура.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстЗапроса()
	
	МассивРеквизитовСТипомДата.Очистить();
	Если ТипЗнч(Запись.ВладелецФайла) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		ТипОбъекта = Запись.ВладелецФайла;
	Иначе
		ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
	КонецЕсли;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	&ПоляВладельцаФайла
		|ИЗ
		|	#ПолноеИмяВладелецФайла";
	
	ПоляВладельцаФайла = ТипОбъекта.Имя + ".Ссылка";
	Если ВсеСправочники.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Справочник = Метаданные.Справочники[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Справочник.Реквизиты Цикл
			ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя;
		КонецЦикла;
	ИначеЕсли ВсеДокументы.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Документ = Метаданные.Документы[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Документ.Реквизиты Цикл
			ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя;
			Если Реквизит.Тип.СодержитТип(Тип("Дата")) Тогда
				МассивРеквизитовСТипомДата.Добавить(Реквизит.Имя, Реквизит.Синоним);
				ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС 
					+ СтрЗаменить("РАЗНОСТЬДАТ(&ИмяРеквизита, &ТекущаяДата, ДЕНЬ) Как ДнейДоУдаленияОт&ИмяРеквизита",
						"&ИмяРеквизита", Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляВладельцаФайла", ПоляВладельцаФайла);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПолноеИмяВладелецФайла", ТипОбъекта.ПолноеИмя + " КАК " + ТипОбъекта.Имя);
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьУсловиеПоДате(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивЗначений", МассивРеквизитовСТипомДата);
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ДобавлениеУсловияПоДате", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение)
	
	ОтборПоИнтервалу = Правило.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборПоИнтервалу.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДнейДоУдаленияОт" + ВыбранноеЗначение.РеквизитСТипомДата);
	ОтборПоИнтервалу.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборПоИнтервалу.ПравоеЗначение = ВыбранноеЗначение.ИнтервалИсключение;
	ПредставлениеРеквизитаСТипомДата = МассивРеквизитовСТипомДата.НайтиПоЗначению(ВыбранноеЗначение.РеквизитСТипомДата).Представление;
	ТекстПредставления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очищать спустя %1 дней относительно даты (%2)'"), 
		ВыбранноеЗначение.ИнтервалИсключение, ПредставлениеРеквизитаСТипомДата);
	ОтборПоИнтервалу.Представление = ТекстПредставления;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	СинхронизацияСправочника = ОбъектСинхронизации = "ВсеФайлы";
	
#Если МобильныйКлиент Тогда
	Элементы.ПравилоСинхронизацииГруппа.Видимость = СинхронизацияСправочника;
	Элементы.ЭлементСправочника.Видимость = Не СинхронизацияСправочника;
#Иначе
	Элементы.ПравилоСинхронизацииГруппа.Доступность = СинхронизацияСправочника;
	Элементы.ЭлементСправочника.Доступность = Не СинхронизацияСправочника;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ЭлементСправочникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующихНастроек;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(ЭлементСправочника, ИдентификаторВладельцаФайлов), ПараметрыФормыВыбора, Элементы.ЭлементСправочника);
	
КонецПроцедуры
 
&НаСервереБезКонтекста
Функция ПутьФормыВыбора(ВладелецФайла, ИдентификаторВладельцаФайлов)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторВладельцаФайлов);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаСервере
Функция СуществующиеОбъектыСинхронизации(ТипВладельцаФайла)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСинхронизацииФайлов.ВладелецФайла
		|ИЗ
		|	РегистрСведений.НастройкиСинхронизацииФайлов КАК НастройкиСинхронизацииФайлов
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(НастройкиСинхронизацииФайлов.ВладелецФайла) = &ТипВладельцаФайла";
	
	Запрос.УстановитьПараметр("ТипВладельцаФайла", ТипВладельцаФайла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВладелецФайла");
	
КонецФункции

&НаСервере
Функция ЕстьНастройкаПравиламСинхронизации(ВладелецФайла)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ИСТИНА КАК ЕстьНастройкаПравиламСинхронизации
		|ИЗ
		|	РегистрСведений.НастройкиСинхронизацииФайлов КАК НастройкиСинхронизацииФайлов
		|ГДЕ
		|	НастройкиСинхронизацииФайлов.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = РезультатЗапроса.Выгрузить()[0];

	Возврат ЗначениеЗаполнено(Результат.ЕстьНастройкаПравиламСинхронизации);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьУчетнуюЗаписьСинхронизации()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиСинхронизацииФайлов.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиСинхронизацииФайлов КАК УчетныеЗаписиСинхронизацииФайлов
		|ГДЕ
		|	НЕ УчетныеЗаписиСинхронизацииФайлов.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Запись.УчетнаяЗапись = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти