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
	Доверенность = Параметры.Доверенность;
	НомерДоверенности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Доверенность, "НомерДоверенности");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьДоверенность(Команда)
	Если ПроверитьЗаполнение() Тогда
		ДанныеОтмены = МашиночитаемыеДоверенностиФНССлужебныйВызовСервера.ПолучитьФайлОтменыДоверенности(Доверенность, ПричинаОтмены);
		ОписаниеДанных = Новый Структура;
		ОписаниеДанных.Вставить("Операция", НСтр("ru='Отмена доверенности'"));
		ОписаниеДанных.Вставить("ЗаголовокДанных", НСтр("ru='Доверенность'"));
		ОписаниеДанных.Вставить("Данные", ДанныеОтмены.Содержимое);

		ЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных,,Новый ОписаниеОповещения("ПослеПодписанияДоверенности", ЭтотОбъект, ДанныеОтмены));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПодписанияДоверенности(Результат, ДанныеОтмены) Экспорт
	Если Результат.Успех Тогда
		
		Если ТипЗнч(Результат.СвойстваПодписи) = Тип("Структура") Тогда
			СвойстваПодписи = Результат.СвойстваПодписи;
		Иначе
			СвойстваПодписи = ПолучитьИзВременногоХранилища(Результат.СвойстваПодписи);
		КонецЕсли;
	
		Если Не СвойстваПодписи.ПодписьВерна 
			И СвойстваПодписи.ТребуетсяПроверка = Ложь Тогда
			
			ТекстОшибки = НСтр("ru='Сертификат подписи не прошел проверку.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			
		КонецЕсли;
		
		РезультатПроверки = ПроверитьСертификатДоверителя(Доверенность, СвойстваПодписи.Сертификат);
		Если ЗначениеЗаполнено(РезультатПроверки.Ошибка) Тогда
			КонтекстОшибки = МашиночитаемыеДоверенностиФНССлужебныйКлиент.КонтекстДляОбработкиОшибкиРР();
			КонтекстОшибки.ЗаголовокПредупреждения = НСтр("ru='Подпись не подходит для отмены'");
			МашиночитаемыеДоверенностиФНССлужебныйКлиент.ОбработатьОшибкуВзаимодействияРР(РезультатПроверки.Ошибка, КонтекстОшибки);
			Возврат;
		КонецЕсли;
		
		РезультатОтмены = МашиночитаемыеДоверенностиФНССлужебныйВызовСервера.ОтменитьМЧДРР(ДанныеОтмены.ИмяФайла, ДанныеОтмены.Содержимое, СвойстваПодписи.Подпись, ДанныеОтмены.Доверенность);
		
		Если ЗначениеЗаполнено(РезультатОтмены.Ошибка) Тогда
			КонтекстОшибки = МашиночитаемыеДоверенностиФНССлужебныйКлиент.КонтекстДляОбработкиОшибкиРР();
			КонтекстОшибки.ЗаголовокПредупреждения = НСтр("ru='Не удается отменить доверенность'");
			МашиночитаемыеДоверенностиФНССлужебныйКлиент.ОбработатьОшибкуВзаимодействияРР(РезультатОтмены.Ошибка, КонтекстОшибки);
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru='Заявление отправлено'"), ПолучитьНавигационнуюСсылку(Доверенность), 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Отмена доверенности %1.'"), НомерДоверенности));
		ДобавитьФайлОтзываИПолучитьРезультатРегистрации(ДанныеОтмены, СвойстваПодписи);
		ОповеститьОбИзменении(Доверенность);
		
		Оповестить("РегистрацияОтмены", Доверенность, "ФормаОтмены");
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры   

&НаСервере
Процедура ДобавитьФайлОтзываИПолучитьРезультатРегистрации(Знач ДанныеОтмены, Знач СвойстваПодписи)
	ФайлДоверенности = Новый Файл(ДанныеОтмены.ИмяФайла);
	ПараметрыДобавления = РаботаСФайлами.ПараметрыДобавленияФайла();
	ПараметрыДобавления.ВладелецФайлов = Доверенность;
	ПараметрыДобавления.ИмяБезРасширения = ФайлДоверенности.ИмяБезРасширения;
	ПараметрыДобавления.РасширениеБезТочки = ФайлДоверенности.Расширение;
	ПараметрыДобавления.Служебный = Истина;
	ФайлЗаявленияНаОтмену = РаботаСФайлами.ДобавитьФайл(ПараметрыДобавления, ДанныеОтмены.Содержимое);
	
	ЭлектроннаяПодпись.ДобавитьПодпись(ФайлЗаявленияНаОтмену, СвойстваПодписи);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
	    ЭлементБлокировки = Блокировка.Добавить("Справочник.МашиночитаемыеДоверенности");
	    ЭлементБлокировки.УстановитьЗначение("Ссылка", Доверенность);
	    Блокировка.Заблокировать();
		
		ОбъектМЧД = Доверенность.ПолучитьОбъект();
		ОбъектМЧД.ФайлЗаявленияНаОтмену = ФайлЗаявленияНаОтмену;
		ОбъектМЧД.ДатаОтмены = ТекущаяДатаСеанса();
		ОбъектМЧД.Статус = Перечисления.СтатусыМЧД.НеДействует;
		ОбъектМЧД.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьСертификатДоверителя(Знач Доверенность, Знач Сертификат)
	Результат = Новый Структура;
	Результат.Вставить("Ошибка");
	
	ФайлДоверенности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Доверенность, "ФайлДоверенности");
	РезультатПроверки = МашиночитаемыеДоверенностиФНССлужебный.ПроверитьСертификатДоверителя(Доверенность, ФайлДоверенности, Сертификат, Ложь);
	Если РезультатПроверки <> Истина Тогда
		ПараметрыОшибкиМЧДРР = МашиночитаемыеДоверенностиФНССлужебный.ПараметрыОшибкиМЧДРР(НСтр("ru='Подпись не подходит для отмены'"), РезультатПроверки);
		Результат.Ошибка = МашиночитаемыеДоверенностиФНССлужебный.ПолучитьИЗаписатьОшибкуМЧДРР(ПараметрыОшибкиМЧДРР);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти