///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПриЗаписиУчетнойЗаписиЭлектроннойПочты(Источник, Отказ) Экспорт

	Если Источник.ОбменДанными.Загрузка Тогда
	
		Возврат;
	
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПапкиЭлектронныхПисем.Ссылка
	               |ИЗ
	               |	Справочник.ПапкиЭлектронныхПисем КАК ПапкиЭлектронныхПисем
	               |ГДЕ
	               |	ПапкиЭлектронныхПисем.ПредопределеннаяПапка
	               |	И ПапкиЭлектронныхПисем.Владелец = &УчетнаяЗапись";
	
	Запрос.УстановитьПараметр("УчетнаяЗапись",Источник.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		УправлениеЭлектроннойПочтой.СоздатьПредопределенныеПапкиЭлектронныхПисемДляУчетнойЗаписи(Источник.Ссылка);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ИмяДокумента, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 50 РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДокументВзаимодействий.Ссылка КАК Ссылка
	|ИЗ
	|	#ИмяДокумента КАК ДокументВзаимодействий
	|ГДЕ
	|	ДокументВзаимодействий.Тема ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~""
	|	ИЛИ ДокументВзаимодействий.Номер ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~""";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяДокумента", "Документ" + "." + ИмяДокумента);
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СтрокаПоиска", ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(Параметры.СтрокаПоиска) + "%");
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ЗаполнитьНаборыЗначенийДоступа(Объект, Таблица) Экспорт
	
	ВзаимодействияПереопределяемый.ПриЗаполненииНаборовЗначенийДоступа(Объект, Таблица);
	
	Если Таблица.Количество() = 0 Тогда
		Взаимодействия.ЗаполнитьНаборыЗначенийДоступаПоУмолчанию(Объект, Таблица);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
