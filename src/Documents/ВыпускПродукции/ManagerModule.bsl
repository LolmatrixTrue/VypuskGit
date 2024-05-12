#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
// СтандартныеПодсистемы.Печать

// Переопределяет настройки печати для объекта.
//
// Параметры:
//  Настройки - см. УправлениеПечатью.НастройкиПечатиОбъекта.
//
Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт
	
	Настройки.ПриДобавленииКомандПечати = Истина;
	Настройки.ПриОпределенииПолучателей = Истина;
	
КонецПроцедуры




	
	
	
	// Заполняет список команд печати.
	// 
	// Параметры:
	//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
	//
	Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
		 
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Идентификатор = "ПФ_MXL_Накладная";
			КомандаПечати.Представление = НСтр("ru = 'Накладная'");
			КомандаПечати.Порядок       = 1;
			
			// Печать Бирок КЗКТ
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Идентификатор = "ПФ_MXL_БиркиКЗКТМ";
			КомандаПечати.Представление = НСтр("ru = 'Бирки КЗКТМ'");
			КомандаПечати.Порядок       = 2;
			
			
			
			// Сертификат качества в Microsoft Word.
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Идентификатор = "СертификатКачества(MSWord)";
			КомандаПечати.Представление = НСтр("ru = 'Сертификат качества в Microsoft Word'");
			КомандаПечати.Картинка = БиблиотекаКартинок.ФорматWord2007;
			КомандаПечати.Обработчик = "ПечатьСертификатаКачества.ПечатьСертификатаКачестваВОфисномДокументе";
			
			
			//печать комплекта
			
			КомандаПечати = КомандыПечати.Добавить();
			КомандаПечати.Идентификатор = "ПФ_MXL_Накладная,ПФ_MXL_БиркиКЗКТМ";
			
			КомандаПечати.Представление = НСтр("ru = 'Печать комплекта документов'");
			КомандаПечати.Порядок       = 5;  
				
		       	
	КонецПроцедуры    
	
	// Подготавливает данные объекта к выводу на печать.
// 
// Параметры:
//  МассивДокументов - Массив - ссылки на объекты, для которых запрашиваются данные для печати;
//  МассивИменМакетов - Массив - имена макетов, в которые подставляются данные для печати.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - коллекция ссылок на объекты и их данные:
//   * Ключ - ЛюбаяСсылка - ссылка на объект информационной базы;
//   * Значение - Структура:
//    ** Ключ - Строка - имя макета,
//    ** Значение - Структура - данные объекта.
//
Функция ПолучитьДанныеПечати(Знач МассивДокументов, Знач МассивИменМакетов) Экспорт
	
		ДанныеПоВсемОбъектам = Новый Соответствие;
		
		Для Каждого ОбъектСсылка Из МассивДокументов Цикл
			ДанныеОбъектаПоМакетам = Новый Соответствие;
			Для Каждого ИмяМакета Из МассивИменМакетов Цикл
				ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, ДанныеОбъекта(ОбъектСсылка));
			КонецЦикла;
			ДанныеПоВсемОбъектам.Вставить(ОбъектСсылка, ДанныеОбъектаПоМакетам);
		КонецЦикла;
		
		ОписаниеОбластей = Новый Соответствие;
		ДвоичныеДанныеМакетов = Новый Соответствие;
		ТипыМакетов = Новый Соответствие; // Для обратной совместимости.
		Объект = МассивДокументов[0].ПолучитьОбъект();
		
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл  
			ТребуетсяГост = Ложь; 
			КоличествоВыгружаемыхОбъектов = 0;
			Для Каждого СтрокаТабличнойЧасти Из Объект.СписокКабелей Цикл  
				Если СтрокаТабличнойЧасти.ВыгружатьВыделеннуюСтроку Тогда
					Если  ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидСертификата) Тогда
						
						ВидСертификата = СтрокаТабличнойЧасти.ВидСертификата;
																		
						Если ВидСертификата = Перечисления.ВидыСертификатов.ТУ003 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваТУ003";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.ТУ004 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваТУ004";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.ТУ007 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваТУ007";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.ТУ008 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваТУ008";
							ТребуетсяГост = Истина;
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.ТУ499 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваТУ499";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.СиловойТУ304 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваСиловойТУ304";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.СиловойТУ310 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваСиловойТУ310";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.СиловойТУ337 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваСиловойТУ337"; 
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ090 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваКонтрольныйТУ090";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ304 Тогда
							ТребуетсяГост = Истина;
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваКонтрольныйТУ304"; 
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ310 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваКонтрольныйТУ310";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ339 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачестваКонтрольныйТУ339";
						ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.АС_839_2019 Тогда 
							ИмяМакетаWord = "Документ.ВыпускПродукции.ПФ_DOC_СертификатКачества839_2019"; 
											
						КонецЕсли; 
						
					Иначе
						ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран вид сертификата'"));
						
					КонецЕсли;	
				КонецЕсли;
			КонецЦикла;
		
		Если ИмяМакета = "СертификатКачества(MSWord)" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, 
			УправлениеПечатью.МакетПечатнойФормы(ИмяМакетаWord));
			ТипыМакетов.Вставить(ИмяМакета, "DOC"); // Для обратной совместимости.
			
			
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ОписаниеОбластейМакетаОфисногоДокумента());
		
	КонецЦикла;
	
	Макеты = Новый Структура;
	Макеты.Вставить("ОписаниеОбластей", ОписаниеОбластей);
	Макеты.Вставить("ТипыМакетов", ТипыМакетов); // Для обратной совместимости.
	Макеты.Вставить("ДвоичныеДанныеМакетов", ДвоичныеДанныеМакетов);
	
	Результат = Новый Структура;
	Результат.Вставить("Данные", ДанныеПоВсемОбъектам);
	Результат.Вставить("Макеты", Макеты);
	
	Возврат Результат;
	
КонецФункции  




////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

Функция ДанныеОбъекта(СсылкаНаОбъект)

	УстановитьПривилегированныйРежим(Истина);
	
	Объект = СсылкаНаОбъект.ПолучитьОбъект();
	
	ДанныеОбъекта = Новый Структура;
	
	ДанныеОбъекта.Вставить("Дата",       Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
	
	
	ТребуетсяГост = Истина;
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокКабелей Цикл 
		
	Если СтрокаТабличнойЧасти.ВыгружатьВыделеннуюСтроку и (НЕ СтрокаТабличнойЧасти.Тара.Предопределенный 
			или НЕ ТипЗнч(СтрокаТабличнойЧасти.Отрезок) = Тип("СправочникСсылка.Отрезки")) Тогда 
			
			
			ДанныеОбъекта =  Данные(ДанныеОбъекта, СтрокаТабличнойЧасти, Объект);
					
		ИначеЕсли   СтрокаТабличнойЧасти.ВыгружатьВыделеннуюСтроку и  (СтрокаТабличнойЧасти.Тара.Предопределенный 
			или ТипЗнч(СтрокаТабличнойЧасти.Отрезок) = Тип("СправочникСсылка.Отрезки")) Тогда 
			
			Ошибки = Новый Массив; // Массив из Строка
			
			Ошибки.Добавить("Для бухт, мешков и отрезков формирование сертификата не предусмотрено."); 
			
			Если Ошибки.Количество() > 0 Тогда
				
				ВызватьИсключение  СтрСоединить(Ошибки, "; ");
				
			КонецЕсли; 

		КонецЕсли;
		
	КонецЦикла; 
	
	
   	
Возврат ДанныеОбъекта;
	
	
КонецФункции 

Функция  Данные(ДанныеОбъекта, СтрокаТабличнойЧасти, Объект) 
	
	ТребуетсяГост = Ложь;
	
	
	ВидСертификата = СтрокаТабличнойЧасти.ВидСертификата;
	
	
	Если ВидСертификата = Перечисления.ВидыСертификатов.ТУ008 Тогда 
		
		ТребуетсяГост = Истина;
		
	ИначеЕсли ВидСертификата = Перечисления.ВидыСертификатов.СиловойТУ310 Тогда 
		
		Если Объект.Дата>='2023.06.15' Тогда
			
			ЗначенияСертификатаСоответствия = ОбщегоНазначенияСервер.СертификатСоответствия(Справочники.КлючевыеЗначения.НайтиПоКоду("000000002").Значение);
		Иначе
			ЗначенияСертификатаСоответствия = ОбщегоНазначенияСервер.СертификатСоответствия(Справочники.КлючевыеЗначения.НайтиПоКоду("000000001").Значение);
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если  ЗначенияСертификатаСоответствия<>Неопределено и ЗначениеЗаполнено(ЗначенияСертификатаСоответствия.НачалоСрокаДействияЕАЭRU) 
		и ЗначениеЗаполнено(ЗначенияСертификатаСоответствия.СертификатСоответствияЕАЭRU)
		и ЗначениеЗаполнено(ЗначенияСертификатаСоответствия.ОкончаниеСрокаДействияЕАЭRU) Тогда
		
		 ДанныеОбъекта.Вставить("НомерЕАЭRU", СОКРЛП(ЗначенияСертификатаСоответствия.СертификатСоответствияЕАЭRU));                                                                                      
		 ДанныеОбъекта.Вставить("НСДЕАЭRU", СОКРЛП(ЗначенияСертификатаСоответствия.НачалоСрокаДействияЕАЭRU));
		ДанныеОбъекта.Вставить("СЕАЭRU", СОКРЛП(ЗначенияСертификатаСоответствия.ОкончаниеСрокаДействияЕАЭRU));
		
		ДанныеОбъекта.Вставить("ОСДЕАЭRU", СОКРЛП(ЗначенияСертификатаСоответствия.ОкончаниеСрокаДействияЕАЭRU)); 
	Иначе  
		ДанныеОбъекта.Вставить("НСДЕАЭRU", "");
		
		ДанныеОбъекта.Вставить("ССЕАЭRU", "");
		ДанныеОбъекта.Вставить("ОСДЕАЭRU", "");
		
	КонецЕсли;
	
	Если  ЗначениеЗаполнено(СтрокаТабличнойЧасти.PID) Тогда
		
		ДанныеОбъекта.Вставить("PID", СтрокаТабличнойЧасти.PID); 
		
	Иначе
		ДанныеОбъекта.Вставить("PID", ""); 
	КонецЕсли; 
	
	
	НеТиповаяТара = ?(СтрокаТабличнойЧасти.Тара = Справочники.Тара.Мешок или СтрокаТабличнойЧасти.Тара = Справочники.Тара.Бухта, Истина, Ложь);
	
	
	Длина     = ?(НеТиповаяТара, СтрокаТабличнойЧасти.Количество, СтрокаТабличнойЧасти.Количество*1000);         
	
	Если   не СтрокаТабличнойЧасти.РучноеРедактированиеРазмерКабеляИОтрезок и  не СтрокаТабличнойЧасти.РучноеРедактированиеКоличествоСтрокой  тогда
		
		Длина     = ?(НеТиповаяТара , СтрокаТабличнойЧасти.Количество, СтрокаТабличнойЧасти.Количество*1000);
	
	ИначеЕсли СтрокаТабличнойЧасти.РучноеРедактированиеКоличествоСтрокой Тогда  
		
		
		МассивПодстрок  = 	СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаТабличнойЧасти.КоличествоСтрокой,"+",Истина,Истина);  
		Если МассивПодстрок.Количество()<>0  Тогда
			Для Н =0 по МассивПодстрок.Количество()-1 Цикл  
				Попытка
					Если Н = 0 Тогда
						СтрДлиннна = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н]);
					ИначеЕсли Н = 1 Тогда 
						СтрДлиннна = ""+СтрДлиннна*1000+"+"+СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н])*1000;
					Иначе 
						СтрДлиннна = СтрДлиннна+"+"+СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н])*1000; 
					КонецЕсли;
				Исключение
					ОбщегоНазначения.СообщитьПользователю("ошибка исполнения, сообщите администратору");
				КонецПопытки;
				
			КонецЦикла;
			
			Длина = ""+СтрДлиннна+" ="+Формат(СтрокаТабличнойЧасти.Количество*1000,"ЧГ=0" );
			
		КонецЕсли;
		
						
	ИначеЕсли СтрокаТабличнойЧасти.РучноеРедактированиеРазмерКабеляИОтрезок Тогда
		Длина     = Формат(СтрокаТабличнойЧасти.Количество*1000, "ЧН=-") ;		 					
	
	КонецЕсли;
	
	ДанныеОбъекта.Вставить("Длина", Длина);
	Если Не СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.АС_839_2019 тогда
		ПредставлениеМаркиВWord    = ""+ СтрокаТабличнойЧасти.Марка.Наименование + " "+СтрокаТабличнойЧасти.Размер;
	Иначе 
		 ПредставлениеМаркиВWord    = ""+ СтрокаТабличнойЧасти.Марка.Наименование ;
	КонецЕсли;
	ДанныеОбъекта.Вставить("Марка", ПредставлениеМаркиВWord);
	
	
	
	
	
	
	Если НЕ СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ304 и
		НЕ СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ310 и
		НЕ СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ339 и
		НЕ   СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ090
		Тогда
		
		
		Напряжение     = Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрЗаменить(СтрокаТабличнойЧасти.Марка.Напряжение.Наименование, "В", "" ))/1000, "ЧН=;");
		
		Если Не СтрокаТабличнойЧасти.ВидСертификата = Перечисления.ВидыСертификатов.КонтрольныйТУ090 Тогда
			ДанныеОбъекта.Вставить("Напряжение", Напряжение);
		Иначе
			Напряжение     = Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрЗаменить(СтрокаТабличнойЧасти.Марка.Напряжение.Наименование, "В-УФ", "" ))/1000, "ЧН=;");
			ДанныеОбъекта.Вставить("Напряжение", Напряжение);
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	ВесНеттоБрутто  = ""+Формат(СтрокаТабличнойЧасти.ВесНетто, "ЧГ=0")+"/"+Формат(СтрокаТабличнойЧасти.ВесБрутто, "ЧГ=0"); 
	ДанныеОбъекта.Вставить("ВесНеттоБрутто", ВесНеттоБрутто);	
	
	СтрокиГОСТ = СтрРазделить(СтрокаТабличнойЧасти.Гост, ",");
	
	Если СтрокиГОСТ<>Неопределено И СтрокиГОСТ.Количество() = 2 Тогда
		
		Если Не ТребуетсяГост Тогда
			ДанныеОбъекта.Вставить("Гост", СтрокиГОСТ[0]);
			
			
		КонецЕсли;
		ДанныеОбъекта.Вставить("СоответствиеГосту", СтрокиГОСТ[0]);
		
		ДанныеОбъекта.Вставить("ТехническиеТребования", СтрокиГОСТ[1]);
		
		
		Если  не ТребуетсяГост Тогда 
			ДанныеОбъекта.Вставить("СоответствиеТТ", СтрокиГОСТ[1]);
			
			
		КонецЕсли;
	Иначе  
		ДанныеОбъекта.Вставить("СоответствиеТТ", Строка(СтрокаТабличнойЧасти.Гост));
	КонецЕсли;
	  
		ДанныеОбъекта.Вставить("НомерИспытания", Строка(СтрокаТабличнойЧасти.НомерИспытания));
		
		
	Если СтрокаТабличнойЧасти.Марка.Напряжение.Наименование ="1000В" Тогда
		ДанныеОбъекта.Вставить("НДБП",	"Не должно быть пробоя при 3,5");
	ИначеЕсли СтрокаТабличнойЧасти.Марка.Напряжение.Наименование ="660В" Тогда
		ДанныеОбъекта.Вставить("НДБП",	"Не должно быть пробоя при 3,0");
		
	Иначе
		ДанныеОбъекта.Вставить("НДБП",	"Не должно быть пробоя при 2,5");
		
	КонецЕсли;
	
	
	КонтролерКачества = Константы.КонтролерКачества.Получить();
	
	ДанныеОбъекта.Вставить("КонтролерКачества",	КонтролерКачества);
	
	
	МНомер = СтрРазделить( СтрокаТабличнойЧасти.Тара, "№");
	
	Если МНомер.Количество()>1 Тогда
		ДанныеОбъекта.Вставить("ТараНомер", МНомер[1]);
		
	КонецЕсли;
	
	Если  СтрНайти(НРег(СтрокаТабличнойЧасти.Марка.Родитель), НРег("Контрол"), НаправлениеПоиска.СНачала)>0  Тогда  
		 //TODO добавить в справочник марки кабеля признак контрольный силовой монтажный
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("ИмяГруппыЖила", "Сопротивление жилы Контрольные"); 
		ИменаГрупп.Вставить("ИмяГруппыИзоляция", "Сопротивление изоляции Контрольные");
		
		СтруктураТекДанных = ФормированиеСтруктурыТекущихДанных.СформироватьСтруктуру(СтрокаТабличнойЧасти); 
		Возврат 	РаботаСWord.ЗаполнитьЗначенияWord(СтруктураТекДанных,ИменаГрупп,ТребуетсяГост,ДанныеОбъекта);
		
		
		
	Иначе  //Силовые    
		
		ИменаГрупп = Новый Структура;
		ИменаГрупп.Вставить("ИмяГруппыЖила", "Сопротивление жилы Силовые"); 
		ИменаГрупп.Вставить("ИмяГруппыИзоляция", "Сопротивление изоляции Силовые");  
		
		СтруктураТекДанных = ФормированиеСтруктурыТекущихДанных.СформироватьСтруктуру(СтрокаТабличнойЧасти); 
		Возврат 	РаботаСWord.ЗаполнитьЗначенияWord(СтруктураТекДанных,ИменаГрупп,ТребуетсяГост,ДанныеОбъекта);
		
		
	КонецЕсли;  
	
   	   
КонецФункции

Функция ОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ВерхнийКолонтитул",	"ВерхнийКолонтитул");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "НижнийКолонтитул",		"НижнийКолонтитул");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Абзац",				"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Заголовок",			"Общая");
	Возврат ОписаниеОбластей;
	
КонецФункции

	
	
	
	
	
	// Формирует печатные формы.
	//
	// Параметры:
	//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
	//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
	//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
	//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
	//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
	//
	Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
		
		ПараметрыСтраницы = Новый Структура; 
		ПараметрыСтраницы.Вставить("ОтображатьСетку", Ложь);
		ПараметрыСтраницы.Вставить("Защита", Ложь);
		ПараметрыСтраницы.Вставить("ТолькоПросмотр", Ложь);
		ПараметрыСтраницы.Вставить("ОтображатьЗаголовки", Ложь);
		ПараметрыСтраницы.Вставить("РазмерСтраницы", "A4");
		ПараметрыСтраницы.Вставить("АвтоМасштаб", Истина);
		
		
		
		
		// Печать накладной .
		НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная");
		Если НужноПечататьМакет Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_Накладная",
			НСтр("ru = 'Накладная'"),
			СформироватьПечатнуюФормуНакладной(МассивОбъектов, ОбъектыПечати,,,, ПараметрыСтраницы),
			,
			"Документ.ВыпускПродукции.ПФ_MXL_Накладная");
			
		КонецЕсли;		
		// Печать Бирок КЗКТ
		
		НужноПечататьМакетБК = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_БиркиКЗКТМ");
		Если НужноПечататьМакетБК Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_БиркиКЗКТМ",
			НСтр("ru = 'Бирки КЗКТМ'"),
			СформироватьПечатнуюФормуБиркиКЗКТМ(МассивОбъектов, ОбъектыПечати,,,, ПараметрыСтраницы),
			,
			"Документ.ВыпускПродукции.ПФ_MXL_БиркиКЗКТМ");
			
			
		КонецЕсли;
						
		
		
	КонецПроцедуры
	
	
	Функция СформироватьПечатнуюФормуБиркиКЗКТМ(МассивОбъектов, ОбъектыПечати, ИмяМакета = "ПФ_MXL_БиркиКЗКТМ", ВыводитьПлатежныеРеквизиты = Истина, КодЯзыка = Неопределено, ПараметрыСтраницы) Экспорт  
		
		ТабДок = Новый ТабличныйДокумент;
		ТабДок.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_БиркиКЗКТМ";
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВыпускПродукции.ПФ_MXL_БиркиКЗКТМ");
		
		
		Запрос = Новый Запрос;
		Запрос.Текст = ЗапросыПечатныхФорм.ПолучитьТекстЗапроса(Истина);
		
		Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);   
		
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ОблБирка  = Макет.ПолучитьОбласть("ОбластьБирка|ОбластьРяд");
		
		
		ТабДок.Очистить();
		
		
		ВставлятьРазделительСтраниц = Ложь;
		
		Пока Выборка.Следующий() Цикл  
			
			лкСчетчик = 0;
			Если ТабДок.ВысотаТаблицы > 0 Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			Если НЕ Выборка.СписокКабелей.Пустой() Тогда
				НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
			КонецЕсли;
			
			ВыборкаСписокКабелей = Выборка.СписокКабелей.Выбрать();
			
			Пока ВыборкаСписокКабелей.Следующий() Цикл 
				
				НеСтандартнаяТара = ?(ВыборкаСписокКабелей.Тара = Справочники.Тара.Мешок или ВыборкаСписокКабелей.Тара = Справочники.Тара.Бухта, Истина, Ложь);
				
				
				
				лкСчетчик = лкСчетчик + 1;
				ОблБирка.Параметры.Заполнить(ВыборкаСписокКабелей);
				ОблБирка.Параметры.Марка     = ""+ВыборкаСписокКабелей.Марка.Наименование+" "+ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаСписокКабелей.Марка, "Напряжение");//+" "+ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаСписокКабелей.Марка, "Напряжение");
				Если   не ВыборкаСписокКабелей.РучноеРедактированиеРазмерКабеляИОтрезок и  не ВыборкаСписокКабелей.РучноеРедактированиеКоличествоСтрокой  тогда
					
					ОблБирка.Параметры.Длина     = ?(НеСтандартнаяТара , ВыборкаСписокКабелей.Количество, ВыборкаСписокКабелей.Количество*1000);
					
				ИначеЕсли ВыборкаСписокКабелей.РучноеРедактированиеКоличествоСтрокой Тогда  
					
					ТекстДлина = "";
					МассивПодстрок  = 	СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВыборкаСписокКабелей.КоличествоСтрокой,"+",Истина,Истина);  
					Если МассивПодстрок.Количество()<>0  Тогда
						Для Н =0 по МассивПодстрок.Количество()-1 Цикл  
							Попытка
								Если Н = 0 Тогда
									СтрДлиннна = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н]);
								ИначеЕсли Н = 1 Тогда 
									СтрДлиннна = ""+СтрДлиннна*1000+"+"+СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н])*1000;
								Иначе 
									СтрДлиннна = СтрДлиннна+"+"+СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МассивПодстрок[Н])*1000; 
								КонецЕсли;
							Исключение
								ОбщегоНазначения.СообщитьПользователю("ошибка исполнения, сообщите администратору");
							КонецПопытки;
							
						КонецЦикла;
						
						ОблБирка.Параметры.Длина = ""+СтрДлиннна+" ="+Формат(ВыборкаСписокКабелей.Количество*1000,"ЧГ=0" );
						
					КонецЕсли;
					
								
					
				ИначеЕсли ВыборкаСписокКабелей.РучноеРедактированиеРазмерКабеляИОтрезок Тогда
					ОблБирка.Параметры.Длина     = ВыборкаСписокКабелей.Отрезок;							
					
				КонецЕсли;
				ОблБирка.Параметры.Размер    = ""+ ВыборкаСписокКабелей.Размер + " "+ВыборкаСписокКабелей.ЦветКабеля;
				ОблБирка.Параметры.ВесНетто  = ВыборкаСписокКабелей.ВесНетто; //Окр(лкСтр.Марка.ВесНетто, 0, РежимОкругления.Окр15как20);
				
				ОблБирка.Параметры.ВесБрутто = ВыборкаСписокКабелей.ВесБрутто;//Окр(лкСтр.ВесБрутто, 0, РежимОкругления.Окр15как20);
				ОблБирка.Параметры.Дата      = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy");
				
				
				Если (лкСчетчик % 2) = 0 Тогда
					ТабДок.Присоединить(ОблБирка);
				Иначе    
					ТабДок.Вывести(ОблБирка);
				КонецЕсли; 
				
				Если (лкСчетчик % 4) = 0 Тогда
					
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
					
					
				КонецЕсли; 
				
				
			КонецЦикла;
			
			
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);  
			
		КонецЦикла; 
		
		
		
		ТабДок.ОтображатьСетку = ПараметрыСтраницы.ОтображатьСетку;
		ТабДок.Защита = ПараметрыСтраницы.Защита;
		ТабДок.ТолькоПросмотр = ПараметрыСтраницы.ТолькоПросмотр;
		ТабДок.ОтображатьЗаголовки = ПараметрыСтраницы.ОтображатьЗаголовки;
		ТабДок.РазмерСтраницы = ПараметрыСтраницы.РазмерСтраницы;
		ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ТабДок.АвтоМасштаб = ПараметрыСтраницы.АвтоМасштаб;
		
		
		Возврат ТабДок;
	КонецФункции	
	
	
	
		
	
	Функция СформироватьПечатнуюФормуНакладной(МассивОбъектов, ОбъектыПечати, ИмяМакета = "ПФ_MXL_Накладная", ВыводитьПлатежныеРеквизиты = Истина, КодЯзыка = Неопределено, ПараметрыСтраницы) Экспорт
		
		
		ТабДок = Новый ТабличныйДокумент;
		ТабДок.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Накладная";
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВыпускПродукции.ПФ_MXL_Накладная");
		
		
		
		Запрос       = Новый Запрос;
		Запрос.Текст = ЗапросыПечатныхФорм.ПолучитьТекстЗапроса(Ложь);
		
		Запрос.Параметры.Вставить("Ссылка", МассивОбъектов );    //Строка.Ссылка
		Выборка = Запрос.Выполнить().Выбрать();
		
		ОбластьСписокКабелейШапка = Макет.ПолучитьОбласть("СписокКабелейШапка");
		ОбластьСписокКабелей      = Макет.ПолучитьОбласть("СписокКабелей");
		
		ТабДок.Очистить();
		
		ВставлятьРазделительСтраниц = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если ТабДок.ВысотаТаблицы > 0 Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
			
			ОбластьСписокКабелейШапка.Параметры.Заполнить(Выборка);
			ОбластьСписокКабелейШапка.Параметры.Адресат = ?(Выборка.Адресат ="Не использовать", "", Выборка.Адресат);
			
			Если ВставлятьРазделительСтраниц Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			
			ТабДок.Вывести(ОбластьСписокКабелейШапка);
			ВыборкаСписокКабелей = Выборка.СписокКабелей.Выбрать();
			НПП = 1;
			Пока ВыборкаСписокКабелей.Следующий() Цикл
				ОбластьСписокКабелей.Параметры.НПП = НПП;
				
				РассчитываемоеКоличествоБухт = ?(ВыборкаСписокКабелей.Тара = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Тара.Бухта"), ВыборкаСписокКабелей.РассчитываемоеКоличествоБухт, Ложь);
			
				
				
				Если РассчитываемоеКоличествоБухт<>Ложь  Тогда
					
					МассивПодстрок  = 	СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(РассчитываемоеКоличествоБухт,"+",Истина,Истина);
					
					Для каждого Строка из МассивПодстрок Цикл
						
						ОбластьСписокКабелей.Параметры.НПП = НПП;
						
						Попытка
							РезультатВычисления = ОбщегоНазначения.ВычислитьВБезопасномРежиме(Строка);
							
						Исключение
							Текст = "Ошибка в поле вычисления строки бухты, проверьте знаки ""*  и некоррректные символы"" и  исправьте, данные в накладной  могут быть не корректны";
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, МассивОбъектов[0]);
							
						КонецПопытки;
						
						СтрокаУмножение =   не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Строка);
						Если  не  СтрокаУмножение Тогда
							РезультатВычисления = ОбщегоНазначения.ВычислитьВБезопасномРежиме(Строка);
						Иначе
							Попытка
								
								МассивЧиселУмножение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка,"*",Истина,Истина);
								ЧислоИзСтроки =""+МассивЧиселУмножение[0]+"*"+МассивЧиселУмножение[1]/1000;
								
							Исключение
								
								Текст = "Ошибка в поле вычисления строки бухты, проверьте знаки ""*  и некоррректные символы"" и  исправьте, данные в накладной  могут быть не корректны";
								ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, МассивОбъектов[0]);
								
							КонецПопытки;
							
							
						КонецЕсли;
						ОбластьСписокКабелей.Параметры.Заполнить(ВыборкаСписокКабелей);
						ОбластьСписокКабелей.Параметры.ЕдиницаИзмерения  = ВыборкаСписокКабелей.ЕдиницаИзмерения;
						
						ОбластьСписокКабелей.Параметры.Количество  = ?(СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Строка),Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка)/1000, "ЧЦ=15; ЧДЦ=3; ЧГ=0")
						, ЧислоИзСтроки);
						Попытка
							ОбластьСписокКабелей.Параметры.КоличествоИтого = ?(СтрокаУмножение, Формат(ОбщегоНазначения.ВычислитьВБезопасномРежиме(Строка), "ЧРГ=,"),Формат(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка)/1000, "ЧЦ=15; ЧДЦ=3; ЧГ=0"));
						Исключение
							ОбщегоНазначения.СообщитьПользователю(Нстр("ru='Произошла ошибка при вычислении.'"));
						КонецПопытки;
								
						
						
							ОбластьСписокКабелей.Параметры.Марка =  ""+ВыборкаСписокКабелей.Марка+" "+ВыборкаСписокКабелей.ЦветКабеля;
								
					
					
						ОбластьСписокКабелей.Параметры.ВесБрутто  = "";
						
						ОбластьСписокКабелей.Параметры.Тара = ВыборкаСписокКабелей.Тара;
						
						ТабДок.Вывести(ОбластьСписокКабелей);	
						
						НПП = НПП+1;
					КонецЦикла;	
					
				Иначе 
					
					Если  не ВыборкаСписокКабелей.РучноеРедактированиеКоличествоСтрокой Тогда 
						
						ОбластьСписокКабелей.Параметры.Заполнить(ВыборкаСписокКабелей);
																							
							ОбластьСписокКабелей.Параметры.Марка =  ""+ВыборкаСписокКабелей.Марка+" "+ВыборкаСписокКабелей.ЦветКабеля;
						
						ОбластьСписокКабелей.Параметры.КоличествоИтого  = Формат(ВыборкаСписокКабелей.Количество, "ЧЦ=15; ЧДЦ=3; ЧГ=0");
						
						
						
						Если ВыборкаСписокКабелей.РучноеРедактированиеРазмерКабеляИОтрезок тогда 	
							ОбластьСписокКабелей.Параметры.Заполнить(ВыборкаСписокКабелей);
							ОбластьСписокКабелей.Параметры.ВесБрутто = ВыборкаСписокКабелей.ВесБрутто;
						КонецЕсли; 	
						
					Иначе  								
						
						
						ОбластьСписокКабелей.Параметры.Заполнить(ВыборкаСписокКабелей);
						
          											
						ОбластьСписокКабелей.Параметры.КоличествоИтого = Формат(ВыборкаСписокКабелей.Количество, "ЧДЦ=3; ЧГ=0");
						ОбластьСписокКабелей.Параметры.Количество     = ВыборкаСписокКабелей.КоличествоСтрокой;
						ТабДок.Вывести(ОбластьСписокКабелей);
						
						
					КонецЕсли
					
					
				КонецЕсли;	
				
				Если  РассчитываемоеКоличествоБухт=Ложь и  не ВыборкаСписокКабелей.РучноеРедактированиеКоличествоСтрокой  Тогда
					ТабДок.Вывести(ОбластьСписокКабелей, ВыборкаСписокКабелей.Уровень());
				КонецЕсли;
				НПП = НПП+1;
				
			КонецЦикла;
			
			ДобавитИВывестиТаруТару(ТабДок, Макет, Выборка.Ссылка);
			
				
			ВставлятьРазделительСтраниц = Истина;
			
			
			Если НЕ ВыборкаСписокКабелей.Количество() = 0 Тогда
				УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);  
				
			КонецЕсли;
			
		КонецЦикла;
		
		
		
		ТабДок.ОтображатьСетку = ПараметрыСтраницы.ОтображатьСетку;
		ТабДок.Защита = ПараметрыСтраницы.Защита;
		ТабДок.ТолькоПросмотр = ПараметрыСтраницы.ТолькоПросмотр;
		ТабДок.ОтображатьЗаголовки = ПараметрыСтраницы.ОтображатьЗаголовки;
		ТабДок.РазмерСтраницы = ПараметрыСтраницы.РазмерСтраницы;
		ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		ТабДок.АвтоМасштаб = ПараметрыСтраницы.АвтоМасштаб;
		Возврат ТабДок;
	КонецФункции

	#КонецОбласти
	
	
	#Область СлужебныйПрограммныйИнтерфейс  
	
	

// Конец СтандартныеПодсистемы.Печать

	



	
	Функция ДобавитИВывестиТаруТару(ТабДок, Макет, Ссылка)
		
		
		ОбластьТара  = Макет.ПолучитьОбласть("Тара");
		
		//////////////////////// тара и обшив /////////////////////////
		
		//Тара
		ТаблицаТары  = ЗапросыПечатныхФорм.ПолучитьТаблицуТара("Тара",Ссылка);
		Для каждого Строка из ТаблицаТары Цикл
			Если Строка.Наименование = "Бар №7" тогда
				ОбластьТара.Параметры.Количество7 = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №8" тогда 
				ОбластьТара.Параметры.Количество8 = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №8а" тогда 
				ОбластьТара.Параметры.Количество8а = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №10" тогда 
				ОбластьТара.Параметры.Количество10 = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №12" тогда 
				ОбластьТара.Параметры.Количество12 = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №14" тогда 
				ОбластьТара.Параметры.Количество14 = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №16а" тогда 
				ОбластьТара.Параметры.Количество16а = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №18а" тогда 
				ОбластьТара.Параметры.Количество18а = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №18у" тогда 
				ОбластьТара.Параметры.Количество18у = Строка.Количество;
			ИначеЕсли Строка.Наименование = "Бар №20а" тогда 
				ОбластьТара.Параметры.Количество20а = Строка.Количество;
				
				
				//б/у
			ИначеЕсли Строка.Наименование              = "Бар №7 б/у" тогда
				ОбластьТара.Параметры.Количество7бу    = Строка.Количество;
			ИначеЕсли Строка.Наименование              = "Бар №8 б/у" тогда				
				ОбластьТара.Параметры.Количество8бу   = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №8а  б/у" тогда 
				ОбластьТара.Параметры.Количество8абу  = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №10  б/у" тогда 
				ОбластьТара.Параметры.Количество10бу  = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №12  б/у" тогда 
				ОбластьТара.Параметры.Количество12бу  = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №14" тогда 
				ОбластьТара.Параметры.Количество14бу  = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №16а  б/у" тогда 
				ОбластьТара.Параметры.Количество16абу = Строка.Количество;
			ИначеЕсли Строка.Наименование              = "Бар №18а  б/у" тогда 
				ОбластьТара.Параметры.Количество18абу = Строка.Количество;
			ИначеЕсли Строка.Наименование 			   = "Бар №18у  б/у" тогда 
				ОбластьТара.Параметры.Количество18убу = Строка.Количество;
			ИначеЕсли Строка.Наименование              = "Бар №20а  б/у" тогда 
				ОбластьТара.Параметры.Количество20а   = Строка.Количество;
				
			КонецЕсли;
			
		КонецЦикла;
		
		//Обшив 
		ТаблицаОбшив  = ЗапросыПечатныхФорм.ПолучитьТаблицуТара("Обшив", Ссылка);
		
		Для каждого Строка из ТаблицаОбшив Цикл
			
			Если Строка.Наименование = "Обш 7" тогда
				
				ОбластьТара.Параметры.КоличествоОбшив7    = Строка.Количество;
			ИначеЕсли Строка.Наименование				  = "Обш 8" тогда				
				ОбластьТара.Параметры.КоличествоОбшив8   = Строка.Количество; 				 
			ИначеЕсли Строка.Наименование 				  = "Обш 8а" тогда 				 
				ОбластьТара.Параметры.КоличествоОбшив8а  = Строка.Количество;
			ИначеЕсли Строка.Наименование 				  = "Обш 10" тогда				 
				ОбластьТара.Параметры.КоличествоОбшив10  = Строка.Количество;
			ИначеЕсли Строка.Наименование 				  = "Обш 12" тогда				 
				ОбластьТара.Параметры.КоличествоОбшив12  = Строка.Количество;
			ИначеЕсли Строка.Наименование 				  = "Обш 14" тогда 				 
				ОбластьТара.Параметры.КоличествоОбшив14  = Строка.Количество;
			ИначеЕсли Строка.Наименование 				  = "Обш 16а" тогда				 
				ОбластьТара.Параметры.КоличествоОбшив16а = Строка.Количество;
			ИначеЕсли Строка.Наименование				  = "Обш 18а" тогда 				 
				ОбластьТара.Параметры.КоличествоОбшив18а = Строка.Количество;
			ИначеЕсли Строка.Наименование				  = "Обш 18у" тогда 
				ОбластьТара.Параметры.КоличествоОбшив18у = Строка.Количество;
			ИначеЕсли Строка.Наименование                 = "Обш 20а" тогда 
				ОбластьТара.Параметры.КоличествоОбшив20а = Строка.Количество;
				
				//обшив сплош 			
				
			ИначеЕсли Строка.Наименование 					= "Обш спл 7" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл7    = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш спл 8" тогда    
				ОбластьТара.Параметры.КоличествоОбшивСпл8    = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш спл 8а" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл8а   = Строка.Количество;
			ИначеЕсли Строка.Наименование				    = "Обш  спл 10" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл10   = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш  спл 12" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл12   = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш спл 14" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл14   = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш  спл 16а" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл16а  = Строка.Количество;
			ИначеЕсли Строка.Наименование  					= "Обш  спл18а" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл18а  = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Обш спл 18у" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл18у  = Строка.Количество;
			ИначеЕсли Строка.Наименование                   = "Обш спл 20а" тогда 
				ОбластьТара.Параметры.КоличествоОбшивСпл20а  = Строка.Количество;   				 
			ИначеЕсли Строка.Наименование 					= "Мешок" тогда 
				ОбластьТара.Параметры.КоличествоМешок	    = Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Маты п/п" тогда 
				ОбластьТара.Параметры.КоличествоМат 		= Строка.Количество;
				
			ИначеЕсли Строка.Наименование 					= "Маты п/п 10" тогда 
				ОбластьТара.Параметры.КоличествоМат10 		= Строка.Количество;
				
			ИначеЕсли Строка.Наименование 					= "Маты п/п 12" тогда 
				ОбластьТара.Параметры.КоличествоМат12 		= Строка.Количество;
				
			ИначеЕсли Строка.Наименование 					= "Маты п/п 14" тогда 
				ОбластьТара.Параметры.КоличествоМат14 		= Строка.Количество;
				
			ИначеЕсли Строка.Наименование 					= "Маты п/п 16а" тогда 
				ОбластьТара.Параметры.КоличествоМат16а 		= Строка.Количество;
			ИначеЕсли Строка.Наименование 					= "Поддон" тогда 
				ОбластьТара.Параметры.КоличествоПоддон 	= Строка.Количество;
			КонецЕсли; 
			
		КонецЦикла;
		
		ТабДок.Вывести(ОбластьТара);
				
КонецФункции // ПолучитьТару()
	
	
	
	#КонецОбласти
	
	
	
#КонецЕсли


