﻿перем Организация Экспорт;
перем ПериодНачисления Экспорт;
перем Район Экспорт;
перем ЧастныйСектор Экспорт;
перем Строение Экспорт;
перем МассивПомещений Экспорт;
перем НаборОбъемНачислений Экспорт;
перем НаборОбъемНачисленийПомещений Экспорт;
перем ГраницыПериодаНачисления, ДокументОбъект, НаборВыполненные;

Процедура Инициализировать(МВТ, ПолучаемыеНаборы)  Экспорт 
		
	Схема  = Неопределено;
	Для Сч = 0 По ПолучаемыеНаборы.ВГраница() Цикл
		ДобавитьНаборВСхему(Схема, ПолучаемыеНаборы[Сч].ИмяНабора, ПолучаемыеНаборы[Сч].ТаблицаДляПомещения);
	КонецЦикла;	
	МКД  										= Неопределено;
	Если НЕ ЧастныйСектор = Неопределено И НЕ ЧастныйСектор Тогда
		МКД 									= Строение;
	ИначеЕсли  НЕ ЧастныйСектор = Неопределено Тогда
		МКД 									= Справочники.энргСтроения.ПустаяСсылка();		
	КонецЕсли;
	
	ГраницыПериодаНачисления 					= энргРаботаСПериодомДействия.ГраницыРасчетногоПериода(Организация, ПериодНачисления,Ложь);
	Запрос  									= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.УстановитьПараметр("Организация",					Организация);
	Запрос.УстановитьПараметр("Район", 							Район);
	Запрос.УстановитьПараметр("ЧастныйСектор", 					ЧастныйСектор);
	Запрос.УстановитьПараметр("Строение", 						Строение);
	Запрос.УстановитьПараметр("Помещение", 						МассивПомещений);
	Запрос.УстановитьПараметр("МКД", 							МКД);
	Запрос.УстановитьПараметр("ПериодНачисления", 				ПериодНачисления);
	Запрос.УстановитьПараметр("ПредыдущийПериодНачисления",		ДобавитьМесяц(ПериодНачисления,-1));
	Запрос.УстановитьПараметр("ПериодНовогоТарифа",				Константы.энргДеньНачалаПримененияНовогоТарифа.Получить());
	Запрос.УстановитьПараметр("НачалоПериодаРасчета",			ГраницыПериодаНачисления.НачалоОП);
	Запрос.УстановитьПараметр("ЗавершениеПериодаРасчета",		ГраницыПериодаНачисления.ЗавершениеОП);
	Запрос.УстановитьПараметр("КоличествоДнейВПериодеРасчета",	ГраницыПериодаНачисления.ДнейВПериоде);
	Запрос.УстановитьПараметр("ВидОперацийНачисления",			Перечисления.энргВидыОперацийНачисления.Индивидуальные);
	Запрос.УстановитьПараметр("ТипНачисления",					Перечисления.энргТипыНачислений.ИндивидуальныеНачисления);
	 	
	Запрос.МенеджерВременныхТаблиц 				= МВТ;
	
	Запрос.Выполнить();
		
КонецПроцедуры

Процедура ПередПроведениемМКД(МКД, яДокументСсылка, ПометкаУдаления) Экспорт 
	НачатьТранзакцию();
	
	ДокументОбъект 									= Неопределено;
	ДокументСсылка 									= яДокументСсылка;
	НаборВыполненные 								= Неопределено;
	НаборПрочитан									= Ложь;
	
	Если НЕ ЗначениеЗаполнено(яДокументСсылка)  Тогда
		
		ДокументСсылка 								= Документы.энргНачисление.ПолучитьСсылку(Новый УникальныйИдентификатор());
		ДокументОбъект  							= Документы.энргНачисление.СоздатьДокумент();
		НаборПрочитан								= Истина;
		ДокументОбъект.МКД 							= МКД;				
		ДокументОбъект.УстановитьСсылкуНового(ДокументСсылка);		
		ДокументОбъект.район  						= Район;		
		ДокументОбъект.Дата							= ГраницыПериодаНачисления.ЗавершениеОП-1;
		ДокументОбъект.Организация 					= Организация;
		
		НаборВыполненные 							= РегистрыСведений.энргДокументыНачислений.СоздатьНаборЗаписей();
		НаборВыполненныеДопСвойства 				= НаборВыполненные.ДополнительныеСвойства;
		НаборВыполненныеДопСвойства.Вставить("Замещать", Ложь);
		
		ЗаписьВыполненные							= НаборВыполненные.Добавить();
		ЗаписьВыполненные.Организация 				= Организация;
		ЗаписьВыполненные.Район		 				= Район;
		ЗаписьВыполненные.ПериодНачисления 			= ПериодНачисления;
		ЗаписьВыполненные.ВидОперацийНачисления		= Перечисления.энргВидыОперацийНачисления.Индивидуальные;
		ЗаписьВыполненные.МКД 						= МКД;
		ЗаписьВыполненные.ДокументНачисления 		= ДокументСсылка;
		
	ИначеЕсли ПометкаУдаления Тогда
		ДокументОбъект  							= яДокументСсылка.ПолучитьОбъект();
		НаборПрочитан								= Истина;
		ДокументОбъект.ПометкаУдаления 				= Ложь;
		ДокументОбъект.Дата							= ГраницыПериодаНачисления.ЗавершениеОП-1;
		
		НаборВыполненные 							= РегистрыСведений.энргДокументыНачислений.СоздатьНаборЗаписей();
		
		НаборВыполненные.Отбор.Организация.Установить(Организация);
		НаборВыполненные.Отбор.ПериодНачисления.Установить(ПериодНачисления);
		НаборВыполненные.Отбор.Район.Установить(Район);
		НаборВыполненные.Отбор.ВидОперацийНачисления.Установить(Перечисления.энргВидыОперацийНачисления.Индивидуальные);
		НаборВыполненные.Отбор.МКД.Установить(МКД);
		НаборВыполненныеДопСвойства 				= НаборВыполненные.ДополнительныеСвойства;
		НаборВыполненныеДопСвойства.Вставить("Замещать", Истина);
		
		ЗаписьВыполненные							= НаборВыполненные.Добавить();
		ЗаписьВыполненные.Организация 				= Организация;
		ЗаписьВыполненные.Район		 				= Район;
		ЗаписьВыполненные.ПериодНачисления 			= ПериодНачисления;
		ЗаписьВыполненные.ВидОперацийНачисления 	= Перечисления.энргВидыОперацийНачисления.Индивидуальные;
		ЗаписьВыполненные.МКД 						= МКД;
		ЗаписьВыполненные.ДокументНачисления 		= ДокументСсылка;
		ЗаписьВыполненные.ПометкаУдаления	 		= Ложь;
	КонецЕсли;
	
	НаборОбъемНачислений 							= РегистрыНакопления.энргОбъемНачислений.СоздатьНаборЗаписей();
	НаборОбъемНачислений.Отбор.Регистратор.Установить(ДокументСсылка);
	
	яЧастныйСектор 									= НЕ ЗначениеЗаполнено(МКД);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("Организация",			Организация);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("Район",				Район);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("ПериодНачисления",	ПериодНачисления);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("ЧастныйСектор",		яЧастныйСектор);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("Строение",			МКД);
	НаборОбъемНачислений.ДополнительныеСвойства.Вставить("ДатаРегистратора",	ГраницыПериодаНачисления.ЗавершениеОП-1);
	
	Если Не МассивПомещений = Неопределено Тогда
		НаборПрочитан								= Истина;
		НаборОбъемНачислений.ДополнительныеСвойства.Вставить("Помещение",	МассивПомещений);
		
		НаборОбъемНачислений.Прочитать();		
		СтрокиУдалить 							= Новый Массив;
		
		Для Каждого СтрокаНабора ИЗ НаборОбъемНачислений Цикл
			Если Строение <> СтрокаНабора.Строение Или МассивПомещений.Найти(СтрокаНабора.Помещение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;			
			СтрокиУдалить.Добавить(СтрокаНабора);
		КонецЦикла;
		
		Для Сч = 0 По СтрокиУдалить.ВГраница() Цикл
			НаборОбъемНачислений.Удалить(СтрокиУдалить[Сч]);
		КонецЦикла; 				
	КонецЕсли;
	
	НаборОбъемНачисленийПомещений								= РегистрыНакопления.энргОбъемНачисленийПомещенийСРазделеннымиЛС.СоздатьНаборЗаписей();
	НаборОбъемНачисленийПомещений.Отбор.Регистратор.Установить(ДокументСсылка);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("Организация",		Организация);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("Район",				Район);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("ПериодНачисления",	ПериодНачисления);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("ЧастныйСектор",		яЧастныйСектор);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("Строение",			МКД);
	НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("ДатаРегистратора",	ГраницыПериодаНачисления.ЗавершениеОП - 1);	
	
	Если Не МассивПомещений = Неопределено Тогда					
		НаборОбъемНачисленийПомещений.ДополнительныеСвойства.Вставить("Помещение",	МассивПомещений);		
		
		НаборОбъемНачисленийПомещений.Прочитать();
		СтрокиУдалить 							= Новый Массив;
		
		Для Каждого СтрокаНабора ИЗ НаборОбъемНачисленийПомещений Цикл
			Если Строение <> СтрокаНабора.Строение Или МассивПомещений.Найти(СтрокаНабора.Помещение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;			
			СтрокиУдалить.Добавить(СтрокаНабора);
		КонецЦикла;
		
		Для Сч = 0 По СтрокиУдалить.ВГраница() Цикл
			НаборОбъемНачисленийПомещений.Удалить(СтрокиУдалить[Сч]);
		КонецЦикла; 		
	КонецЕсли;
	
	Если Не НаборПрочитан Тогда
		НаборОбъемНачислений.Записать();
		НаборОбъемНачисленийПомещений.Записать();
	КонецЕсли; 	
	
КонецПроцедуры

Процедура ПослеПроведенияМКД(Ошибки) Экспорт 
	
	Попытка
		Если НЕ ДокументОбъект = Неопределено Тогда
			ДокументОбъект.ДополнительныеСвойства.Вставить("ПроведениеРазрешено",Истина);
			ДокументОбъект.записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;														
		
		Если НЕ НаборВыполненные = Неопределено Тогда
			НаборВыполненные.Записать(НаборВыполненные.ДополнительныеСвойства.Замещать);
		КонецЕсли;
		
		НаборОбъемНачислений.Записать();								
		НаборОбъемНачисленийПомещений.Записать();						
		
		ЗафиксироватьТранзакцию();
	Исключение						
		ОтменитьТранзакцию();
		ИнформацияОбОшибке  					= ИнформацияОбОшибке();
		Ошибки 									= Ошибки +
		Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьНаборВСхему(Схема,ИмяНабора,ТаблицаДляПомещения)
	
	СоотвествиеПолей 						= Новый Структура("Организация,Район,ПериодНачисления, Период","Организация","Район","ПериодНачисления", "НачалоПериодаРасчета");
	
	Если Не ЧастныйСектор = Неопределено Тогда
		СоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строение) Тогда
		СоотвествиеПолей.Вставить("МКД", 		"МКД");
		Если Не ЧастныйСектор = Неопределено И НЕ ЧастныйСектор Или Не МассивПомещений = Неопределено Тогда
			СоотвествиеПолей.Вставить("Строение", 	"Строение");
		КонецЕсли;
	КонецЕсли;
			
	ПараметрыВТ 							= Новый Массив;
	ПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", СоотвествиеПолей));
	
	
	Если Не МассивПомещений = Неопределено Тогда
		СоотвествиеПолей 					= Новый Структура;
		СоотвествиеПолей.Вставить("Помещение", "Помещение");
		ПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
	КонецЕсли;
	
	Параметры  								= Новый Структура("ПараметрыВТ,Период", ПараметрыВТ, Новый Структура("ИмяПараметра","НачалоПериодаРасчета"));
	
	Если ИмяНабора  = "СпособыРасчетаПоНаправлениям" Тогда
		
		РегистрыСведений.энргСпособыРасчетаПоНаправлениям.СпособыРасчетаПоНаправлениям(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ПоставщикиНеНачислять" Тогда
		
		РегистрыСведений.энргПоставщикиНеНачислять.ПоставщикиНеНачислять(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
			
	ИначеЕсли ИмяНабора  = "ЗначенияПовышающихКоэффициентов" Тогда
		
		РегистрыСведений.энгрЗначенияПовышающихКоэффициентов.ЗначенияПовышающихКоэффициентов(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ЗначенияТекущихНормПотребления" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("Организация,Район,ПериодНачисления,ТипНачисления","Организация","Район","ПериодНачисления","ТипНачисления");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
				
		врПараметрыВТ 							= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		
		Если ЗначениеЗаполнено(МассивПомещений) Тогда
			СоотвествиеПолей 					= Новый Структура;
			СоотвествиеПолей.Вставить("Помещение", "Помещение");
			врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
		КонецЕсли;
		
		врПараметры  							= Новый Структура("ПараметрыВТ, Период", врПараметрыВТ, Новый Структура("ИмяПараметра","ЗавершениеПериодаРасчета"));
		
		РегистрыСведений.энргЗначенияНормативовПотребления.ЗначенияТекущихНормПотребления(Схема,врПараметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ЗначенияТекущихСоциальныхНормПотребления" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("Организация,Район,ПериодНачисления,ТипНачисления","Организация","Район","ПериодНачисления","ТипНачисления");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
				
		врПараметрыВТ 							= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		
		Если ЗначениеЗаполнено(МассивПомещений) Тогда
			СоотвествиеПолей 					= Новый Структура;
			СоотвествиеПолей.Вставить("Помещение", "Помещение");
			врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
		КонецЕсли;
		
		врПараметры  							= Новый Структура("ПараметрыВТ,Период", врПараметрыВТ,Новый Структура("ИмяПараметра","ЗавершениеПериодаРасчета"));
		
		РегистрыСведений.энргЗначенияСоциальныхНормативов.ЗначенияТекущихСоциальныхНормПотребления(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ЗначенияТекущихТарифов" Тогда
		
		РегистрыСведений.энргЗначенияТарифов.ЗначенияТекущихТарифов(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора = "ИзменениеТарифовВПериоде" Тогда
		
		РегистрыСведений.энргЗначенияТарифов.ИзменениеТарифовВПериоде(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "НастройкаНачисленияГВСМКД" Тогда
		
		РегистрыСведений.энргНастройкаНачисленияГВСМКД.НастройкаНачисленияГВСМКД(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ТипСхемыГВС" Тогда
		
		РегистрыСведений.энргТипСхемыГВС.ТипСхемыГВС(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ТипПринадлежностиМКД" Тогда
		
		РегистрыСведений.энргТипПринадлежностиМКД.ТипПринадлежностиМКД(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "НастройкаСезонностиУслуг" Тогда
		
		РегистрыСведений.энргНастройкаСезонностиУслуг.НастройкаСезонностиУслуг(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "НормаСкоростиДвиженияВоды" Тогда
		
		РегистрыСведений.энргНормаСкоростиДвиженияВоды.НормаСкоростиДвиженияВоды(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ПериодыСезонности" Тогда
		
		РегистрыСведений.энргДлительностиПериодов.ПериодыСезонности(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ДокументыНачислений" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("Организация,Район,ПериодНачисления,ВидОперацийНачисления","Организация","Район","ПериодНачисления","ВидОперацийНачисления");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
				
		врПараметрыВТ 							= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		
		Если ЗначениеЗаполнено(МассивПомещений) Тогда
			СоотвествиеПолей 					= Новый Структура("Помещение", "Помещение");
			врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
		КонецЕсли;
		
		врПараметры  							= Новый Структура("ПараметрыВТ", врПараметрыВТ);
		РегистрыСведений.энргДокументыНачислений.ДокументыНачислений(Схема,врПараметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "СреднийОбъемПотребленияАбонентов" Тогда
		
		РегистрыСведений.энргСреднийОбъемПотребленияАбонентов.СреднийОбъемПотребленияАбонентов(Схема,Параметры,ТаблицаДляПомещения);	
		
	ИначеЕсли ИмяНабора  = "СтабильныеПериодыШкалы" Тогда
		
		РегистрыСведений.энргСтабильныеПериоды.СтабильныеПериодыШкалы(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "СтабильныеПериодыИзмерителиНаправлений" Тогда
		
		РегистрыСведений.энргСтабильныеПериоды.СтабильныеПериодыИзмерителиНаправлений(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "СтабильныеПериодыИзмерителиНаправлений" Тогда
		
	    РегистрыСведений.энргСтабильныеПериоды.СтабильныеПериодыИзмерителиНаправлений(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "МаксимальныеПоказанияСрезПредыдущийПериод" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("Организация,Район,ПериодНачисления,","Организация","Район","ПредыдущийПериодНачисления");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
				
		врПараметрыВТ 							= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		
		Если ЗначениеЗаполнено(МассивПомещений) Тогда
			СоотвествиеПолей 					= Новый Структура;
			СоотвествиеПолей.Вставить("Помещение", "Помещение");
			врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
		КонецЕсли;
			
		врПараметры  							= Новый Структура("ПараметрыВТ", врПараметрыВТ);
		РегистрыСведений.энргПредоставленныеПоказания.МаксимальныеПоказанияСрез(Схема,врПараметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПредыдущийПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "МаксимальныеПоказанияСрез" Тогда
		
		РегистрыСведений.энргПредоставленныеПоказания.МаксимальныеПоказанияСрез(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
			
	ИначеЕсли ИмяНабора  = "ПредоставленныеПоказания" Тогда
		
		РегистрыСведений.энргПредоставленныеПоказания.ПредоставленныеПоказания(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ДанныеВыводаПрибораУчета" Тогда
		
		РегистрыСведений.энргВыводПриборовУчета.ДанныеВыводаПрибораУчета(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ЗначениеПлощадейМКД" Тогда
		
		РегистрыСведений.энргСтабильныеПериодыМКД.ЗначениеПлощадейМКД(Схема,Параметры,ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ЗначениеИндивидуальныхПлощадей" Тогда
		
		врСхема 					= Неопределено;
		
		РегистрыСведений.энргСтабильныеПериоды.ЗначениеИндивидуальныхПлощадейМКД(врСхема,Параметры,"");
		Если ОбщегоНазначения.ПодсистемаСуществует("бестБиллингПроект") Тогда
			РегистрыСведений.бестСтабильныеПериодыНП.ЗначениеИндивидуальныхПлощадейМКД(врСхема,Параметры,"");
		Иначе
			ВызватьИсключение "Метод не реализован";
		КонецЕсли;
		
		ТекстПомещения  			= врСхема.ПакетЗапросов[0].ПолучитьТекстЗапроса();
						
		ТекстНежилые  				= врСхема.ПакетЗапросов[1].ПолучитьТекстЗапроса();
		ТекстОбъединения 			= "ВЫБРАТЬ * ИЗ (" + ТекстПомещения + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС + ТекстНежилые + ") КАК ВложенныйЗапрос";
		
		Пакет 						= Схема.ПакетЗапросов.Добавить(Тип("ЗапросВыбораСхемыЗапроса")); 			
		Пакет.УстановитьТекстЗапроса(ТекстОбъединения);
		Пакет.ТаблицаДляПомещения 	= ТаблицаДляПомещения;
		ОператорВыбора  			= Пакет.Операторы[0];
		ОператорВыбора.ВыбираемыеПоля.Очистить();
		
		ОператорВыбора.ВыбираемыеПоля.Добавить("Организация");
		ОператорВыбора.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		
		КолонкаЗапроса  			= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 	= "ПериодНачисления";
		
		ОператорВыбора.ВыбираемыеПоля.Добавить("Район");
		ОператорВыбора.ВыбираемыеПоля.Добавить("МКД");
		ОператорВыбора.ВыбираемыеПоля.Добавить("Услуга");
		ОператорВыбора.ВыбираемыеПоля.Добавить("СУММА(ВложенныйЗапрос.ПлощадьАбонента)");
		Пакет.Колонки[ОператорВыбора.ВыбираемыеПоля.Количество()-1].Псевдоним = "ПлощадьАбонентов"; 		
		ОператорВыбора.ВыбираемыеПоля.Добавить("СУММА(ВложенныйЗапрос.ПлощадьСобственнаяПоставка)");   		
		Пакет.Колонки[ОператорВыбора.ВыбираемыеПоля.Количество()-1].Псевдоним = "ПлощадьСобственнаяПоставка";
		
	ИначеЕсли ИмяНабора  = "НаличиеПриборовУчетаСНачалаГода" Тогда
		
		РегистрыСведений.энргСтабильныеПериоды.НаличиеПриборовУчетаСНачалаГода(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ДанныеСтабильныхПериодов" Тогда
		
		РегистрыСведений.энргСтабильныеПериоды.СтабильныеПериоды(Схема,Параметры,ТаблицаДляПомещения);
		
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 								= Пакет.Операторы[0];
		Оператор.ВыбираемыеПоля.Добавить("&НачалоПериодаРасчета");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "НачалоОП";
		
		Оператор.ВыбираемыеПоля.Добавить("&ЗавершениеПериодаРасчета");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ЗавершениеОП";
		
		Оператор.ВыбираемыеПоля.Добавить("&КоличествоДнейВПериодеРасчета");
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ДнейВПериоде";
	ИначеЕсли ИмяНабора  = "НастройкиРасчетаСреднегоПотребления" Тогда
		
		РегистрыСведений.энргНастройкиРасчетаСреднегоПотребления.НастройкиРасчетаСреднегоПотребления(Схема,Параметры,ТаблицаДляПомещения);
		Пакет 									= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		ОператорВыбора  						= Пакет.Операторы[0];
		ОператорВыбора.ВыбираемыеПоля.Добавить("&ПериодНачисления");
		
		КолонкаЗапроса  						= Пакет.Колонки[Пакет.Колонки.Количество()-1];
		КолонкаЗапроса.Псевдоним 				= "ПериодНачисления";
		
	ИначеЕсли ИмяНабора  = "ДниИспользованияУслугПриОтсутствии" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("ПериодНачисления, Организация, Район", "ПериодНачисления", "Организация", "Район");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
		
		врПараметрыВТ 							= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		
		Если ЗначениеЗаполнено(МассивПомещений) Тогда
			СоотвествиеПолей 					= Новый Структура("Помещение", "Помещение");
			врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраВСписке", СоотвествиеПолей));
		КонецЕсли;
		
		
		врПараметры  							= Новый Структура("ПараметрыВТ", врПараметрыВТ);
		
		РегистрыНакопления.энргКоличествоДнейИспользованияУслугПриОтсутствии.КоличествоДнейИспользованияУслугПриОтсутствии(Схема, врПараметры, ТаблицаДляПомещения);
		
	ИначеЕсли ИмяНабора  = "ПроцентВетхостиСтроений" Тогда
		
		врСоотвествиеПолей 						= Новый Структура("Организация, Район", "Организация", "Район");
		
		Если Не ЧастныйСектор = Неопределено Тогда
			врСоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строение) Тогда
			врСоотвествиеПолей.Вставить("Строение", "Строение");
		КонецЕсли;
				
		врПараметрыВТ 	= Новый Массив;
		врПараметрыВТ.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", врСоотвествиеПолей));
		врПараметры  	= Новый Структура("Период, ПараметрыВТ", Новый Структура("ИмяПараметра", "ЗавершениеПериодаРасчета"), врПараметрыВТ);
		
		РегистрыСведений.энргПроцентВетхостиСтроения.ПроцентВетхостиСтроения(Схема, врПараметры, ТаблицаДляПомещения);
		
		Пакет 		= Схема.ПакетЗапросов[Схема.ПакетЗапросов.Количество()-1];
		Оператор 	= Пакет.Операторы[0];
		Оператор.Отбор.Добавить("энргПроцентВетхостиСтроенияСрезПоследних.Процент > 0");
				
	КонецЕсли;	
	
КонецПроцедуры





