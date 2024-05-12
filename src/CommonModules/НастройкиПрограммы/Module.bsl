///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Вызывается из обработчика ПриСозданииНаСервере() панели администрирования БСП. Выполняет настройку отображения
// элементов управления для подсистем библиотеки БСП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
//
Процедура ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаКлассификаторы.Видимость = Не Форма.РазделениеВключено;
	
	Если Элементы.ГруппаКлассификаторы.Видимость Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
			МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
			Если Не МодульАдресныйКлассификаторСлужебный.ЕстьПравоДобавлениеИзменениеАдресныхСведений() Тогда
				Элементы.АдресныйКлассификаторНастройки.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Элементы.АдресныйКлассификаторНастройки.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалютСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалютСлужебный");
		Элементы.ГруппаОбработкаЗагрузкаКурсовВалют.Видимость =
			  Не Форма.РазделениеВключено
			И Не Форма.ЭтоАвтономноеРабочееМесто
			И МодульРаботаСКурсамиВалютСлужебный.ЕстьПравоИзмененияКурсовВалют();
	Иначе
		Элементы.ГруппаОбработкаЗагрузкаКурсовВалют.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		Элементы.ГруппаСклонения.Видимость =
			  Не Форма.РазделениеВключено
			И Не Форма.ЭтоАвтономноеРабочееМесто
			И Форма.ЭтоАдминистраторСистемы;
		Если Элементы.ГруппаСклонения.Видимость Тогда
			МодульСклонениеПредставленийОбъектов     = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
			Форма.ИспользоватьСервисСклоненияMorpher =
				МодульСклонениеПредставленийОбъектов.ИспользоватьСервисСклоненияMorpher();
		КонецЕсли;
	Иначе
		Элементы.ГруппаСклонения.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		Элементы.ГруппаЦентрМониторинга.Видимость = Форма.ЭтоАдминистраторСистемы;
		Если Форма.ЭтоАдминистраторСистемы Тогда
			ПараметрыЦентраМониторинга = ПолучитьПараметрыЦентраМониторинга();
			Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = ПолучитьПереключательОтправкиДанных(
				ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга,
				ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме);
			
			ПараметрыСервиса = Новый Структура("Сервер, АдресРесурса, Порт");
			Если Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
				ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.СерверПоУмолчанию;
				ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурсаПоУмолчанию;
				ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.ПортПоУмолчанию;
			ИначеЕсли Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
				ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.Сервер;
				ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурса;
				ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.Порт;
			ИначеЕсли Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
				ПараметрыСервиса = Неопределено;
			КонецЕсли;
			
			Если ПараметрыСервиса <> Неопределено Тогда
				Если ПараметрыСервиса.Порт = 80 Тогда
					Схема = "http://";
					Порт = "";
				ИначеЕсли ПараметрыСервиса.Порт = 443 Тогда
					Схема = "https://";
					Порт = "";
				Иначе
					Схема = "http://";
					Порт = ":" + Формат(ПараметрыСервиса.Порт, "ЧН=0; ЧГ=");
				КонецЕсли;
				
				Форма.ЦентрМониторингаАдресСервиса = Схема
					+ ПараметрыСервиса.Сервер
					+ Порт
					+ "/"
					+ ПараметрыСервиса.АдресРесурса;
			Иначе
				Форма.ЦентрМониторингаАдресСервиса = "";
			КонецЕсли;
			
			Элементы.ЦентрМониторингаАдресСервиса.Доступность = (Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 1);
			Элементы.ЦентрМониторингаНастройки.Доступность = (Форма.ЦентрМониторингаРазрешитьОтправлятьДанные <> 2);
			Элементы.ГруппаОтправитьКонтактнуюИнформацию.Видимость =
				(ПараметрыЦентраМониторинга.ЗапросКонтактнойИнформации <> 2);
		КонецЕсли;
	Иначе
		Элементы.ГруппаЦентрМониторинга.Видимость = Ложь;
	КонецЕсли;
	
	ВидимостьГруппыВнешниеКомпоненты = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда 
		
		МодульВнешниеКомпонентыСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыСлужебный");
		ВидимостьГруппыВнешниеКомпоненты = МодульВнешниеКомпонентыСлужебный.ДоступнаЗагрузкаСПортала();
		
	КонецЕсли;
	
	Элементы.ГруппаВнешниеКомпоненты.Видимость = ВидимостьГруппыВнешниеКомпоненты;
	
	НастройкиПрограммыПереопределяемый.ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма);
	
	Элементы.ГруппаОбсуждения.Видимость = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения");
	
КонецПроцедуры

// Сохраняет новое значение константы панели администрирования "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  ИмяКонстанты - Строка - имя константы, значение которого было изменено.
//  НовоеЗначение - Произвольный
//
Процедура ИнтернетПоддержкаИСервисыПриИзмененииКонстанты(Форма, ИмяКонстанты, НовоеЗначение) Экспорт
	
	СохранитьЗначениеКонстанты(ИмяКонстанты, НовоеЗначение);
	
	Если ИмяКонстанты = "ИспользоватьСервисСклоненияMorpher"
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		
		МодульСклонениеПредставленийОбъектов = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
		МодульСклонениеПредставленийОбъектов.УстановитьДоступностьСервисаСклонения(Истина);
		
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

// Выполняет обработку события ПриИзменении() элементов формы БСП ЦентрМониторингаРазрешитьОтправлятьДанные,
// ЦентрМониторингаРазрешитьОтправлятьДанныеСтороннему, ЦентрМониторингаЗапретитьОтправлятьДанные панели
// администрирования "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Элемент - ПолеФормы
//  ПараметрыОперации - Структура из КлючИЗначение - заполняется параметрами, которые будут переданы для исполнения в
//  клиентской среде.
//
Процедура ИнтернетПоддержкаИСервисыРазрешитьОтправлятьДанныеПриИзменении(Форма, Элемент, ПараметрыОперации) Экспорт
	Перем РезультатЗапуска;
	
	Элементы = Форма.Элементы;
	
	Элементы.ЦентрМониторингаАдресСервиса.Доступность = (Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 1);
	Элементы.ЦентрМониторингаНастройки.Доступность = (Форма.ЦентрМониторингаРазрешитьОтправлятьДанные <> 2);
	Если Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
		ПараметрыЦентраМониторинга =
			Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Ложь, Ложь);
	ИначеЕсли Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
		ПараметрыЦентраМониторинга =
			Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Ложь, Истина);
	ИначеЕсли Форма.ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
		ПараметрыЦентраМониторинга =
			Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Истина, Ложь);
	КонецЕсли;
	
	Форма.ЦентрМониторингаАдресСервиса = ПолучитьАдресСервиса(Форма.ЦентрМониторингаРазрешитьОтправлятьДанные);
	
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	МодульЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
	
	ВключитьЦентрМониторинга = ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга;
	ЦентрОбработкиИнформацииОПрограмме = ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме;
	
	Результат = ПолучитьПереключательОтправкиДанных(ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме);
	Если Результат = 0 Или Результат = 1 Тогда
		РезультатЗапуска = МодульЦентрМониторингаСлужебный.ЗапускОтправкиОзнакомительногоПакета();
		РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики", Истина);
		МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
	ИначеЕсли Результат = 2 Тогда
		МодульЦентрМониторингаСлужебный.УдалитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики");
		МодульЦентрМониторингаСлужебный.ОтключитьРегистрациюСобытий();
	КонецЕсли;
	
	ПараметрыОперации.Вставить("РезультатЗапуска", РезультатЗапуска);
	
КонецПроцедуры

// Выполняет обработку события ПриИзменении() элементов формы БСП ЦентрМониторингаАдресСервиса панели администрирования
// "Интернет-поддержка и сервисы" БСП и БИП.
//
// Параметры:
//  Форма - см. Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы
//  Элемент - ПолеФормы
//
Процедура ИнтернетПоддержкаИСервисыЦентрМониторингаАдресСервисаПриИзменении(Форма, Элемент) Экспорт
	
	Попытка
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Форма.ЦентрМониторингаАдресСервиса);
		СтруктураАдреса.Вставить("ЗащищенноеСоединение", СтруктураАдреса.Схема = "https");
		Если НЕ ЗначениеЗаполнено(СтруктураАдреса.Порт) Тогда
			СтруктураАдреса.Порт = ?(СтруктураАдреса.Схема = "https", 443, 80);
		КонецЕсли;
	Исключение
		// Формат адреса должен соответствовать RFC 3986, см. описание функции ОбщегоНазначенияКлиентСервер.СтруктураURI.
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Адрес сервиса %1 не является допустимым адресом веб-сервиса для отправки отчетов об использовании программы.'"),
			Форма.ЦентрМониторингаАдресСервиса);
		ВызватьИсключение(ОписаниеОшибки);
	КонецПопытки;
	
	ПараметрыЦентраМониторинга = Новый Структура();
	ПараметрыЦентраМониторинга.Вставить("Сервер", СтруктураАдреса.Хост);
	ПараметрыЦентраМониторинга.Вставить("АдресРесурса", СтруктураАдреса.ПутьНаСервере);
	ПараметрыЦентраМониторинга.Вставить("Порт", СтруктураАдреса.Порт);
	ПараметрыЦентраМониторинга.Вставить("ЗащищенноеСоединение", СтруктураАдреса.ЗащищенноеСоединение);
	
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	МодульЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЦентрМониторинга

Функция ПолучитьПереключательОтправкиДанных(ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме)
	Состояние = ?(ВключитьЦентрМониторинга, "1", "0") + ?(ЦентрОбработкиИнформацииОПрограмме, "1", "0");
	
	Если Состояние = "00" Тогда
		Результат = 2;
	ИначеЕсли Состояние = "01" Тогда
		Результат = 1;
	ИначеЕсли Состояние = "10" Тогда
		Результат = 0;
	ИначеЕсли Состояние = "11" Тогда
		// А такого быть не может...
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьАдресСервиса(ЦентрМониторингаРазрешитьОтправлятьДанные)
	
	ПараметрыЦентраМониторинга = ПолучитьПараметрыЦентраМониторинга();
	
	ПараметрыСервиса = Новый Структура("Сервер, АдресРесурса, Порт");
	
	Если ЦентрМониторингаРазрешитьОтправлятьДанные = 0 Тогда
		ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.СерверПоУмолчанию;
		ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурсаПоУмолчанию;
		ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.ПортПоУмолчанию;
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 1 Тогда
		ПараметрыСервиса.Сервер = ПараметрыЦентраМониторинга.Сервер;
		ПараметрыСервиса.АдресРесурса = ПараметрыЦентраМониторинга.АдресРесурса;
		ПараметрыСервиса.Порт = ПараметрыЦентраМониторинга.Порт;
	ИначеЕсли ЦентрМониторингаРазрешитьОтправлятьДанные = 2 Тогда
		ПараметрыСервиса = Неопределено;
	КонецЕсли;
	
	Если ПараметрыСервиса <> Неопределено Тогда
		Если ПараметрыСервиса.Порт = 80 Тогда
			Схема = "http://";
			Порт = "";
		ИначеЕсли ПараметрыСервиса.Порт = 443 Тогда
			Схема = "https://";
			Порт = "";
		Иначе
			Схема = "http://";
			Порт = ":" + Формат(ПараметрыСервиса.Порт, "ЧН=0; ЧГ=");
		КонецЕсли;
		
		АдресСервиса = Схема + ПараметрыСервиса.Сервер + Порт + "/" + ПараметрыСервиса.АдресРесурса;
	Иначе
		АдресСервиса = "";
	КонецЕсли;
	
	Возврат АдресСервиса;
КонецФункции

Функция ПолучитьПараметрыЦентраМониторинга()
	МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
	ПараметрыЦентраМониторинга = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов();
	
	ПараметрыСервисаПоУмолчанию = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыПоУмолчаниюВнешнийВызов();
	ПараметрыЦентраМониторинга.Вставить("СерверПоУмолчанию", ПараметрыСервисаПоУмолчанию.Сервер);
	ПараметрыЦентраМониторинга.Вставить("АдресРесурсаПоУмолчанию", ПараметрыСервисаПоУмолчанию.АдресРесурса);
	ПараметрыЦентраМониторинга.Вставить("ПортПоУмолчанию", ПараметрыСервисаПоУмолчанию.Порт);
	
	Возврат ПараметрыЦентраМониторинга;
КонецФункции

#КонецОбласти

Процедура СохранитьЗначениеКонстанты(ИмяКонстанты, НовоеЗначение)
	
	КонстантаМенеджер = Константы[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> НовоеЗначение Тогда
		КонстантаМенеджер.Установить(НовоеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти