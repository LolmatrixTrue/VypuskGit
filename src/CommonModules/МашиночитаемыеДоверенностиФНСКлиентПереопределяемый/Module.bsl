///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// При начале выбора кода налогового органа.
// 
// Параметры:
//  Организации - Массив из ОпределяемыйТип.СторонаМЧД
//  Оповещение - ОписаниеОповещения - оповещение, которое вернет результат выбора кодов.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеВыбораКодаНалоговогоОргана(Организации, Оповещение, СтандартнаяОбработка) Экспорт
		
КонецПроцедуры

// При начале выбора полномочий.
// 
// Параметры:
//  Оповещение  - ОписаниеОповещения - оповещение, которое вернет результат выбора полномочий.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеВыбораПолномочий(Оповещение, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// При начале подписания.
// 
// Параметры:
//  Организации - Массив из ОпределяемыйТип.СторонаМЧД
//  Файл - СправочникСсылка.МашиночитаемыеДоверенностиПрисоединенныеФайлы
//  Полномочия - ТабличнаяЧасть - СправочникОбъект.МашиночитаемыеДоверенности.Полномочия.
//  Оповещение  - ОписаниеОповещения - оповещение, которое вернет результат подписания.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеПодписания(Организации, Файл, Полномочия, Оповещение, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти
