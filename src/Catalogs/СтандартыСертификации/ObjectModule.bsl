
Процедура ПередЗаписью(Отказ)
		Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СтарыйКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Код");

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() и ЗначениеЗаполнено(СтарыйКод) и СтарыйКод <> Код Тогда
		Ошибка = НСтр("ru = 'Запрещено менять коды этого справочника.'");
		ОбщегоНазначения.СообщитьПользователю(Ошибка,, "Объект.Код",, Отказ);		
	КонецЕсли;

КонецПроцедуры


