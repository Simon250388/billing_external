﻿Перем Организация Экспорт;
Перем ПериодНачисления Экспорт;
Перем Район Экспорт;
Перем ЧастныйСектор Экспорт;
Перем Строение Экспорт;
Перем Помещение Экспорт;
перем НаборПериоды Экспорт ;
перем НаборШкалы Экспорт;
перем НаборИзмерители Экспорт;
Перем ИзменяемыеПараметрыПоТипам, ПоляПорядка, ИзмеренияИсключая, ТаблицыДанных, ТаблицыИзмененияПлощади, ТаблицыИзмененияШкал, ТаблицыИзмененияИзмерителей;

#Область Конструктор

Функция Инициализировать(МВТ) Экспорт 
	
	СоотвествиеПолей 							= Новый Структура("Организация,ПериодНачисления,Район","Организация","ПериодНачисления","Район");
	
	ПоляПорядка 								= "Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение,ПериодРегистрации,ДатаРегистратора,ДокРегистратор";
	мПоляПорядка 								= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляПорядка);
	
	Если НЕ Помещение = Неопределено и ЗначениеЗаполнено(Помещение) Тогда
		СоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		СоотвествиеПолей.Вставить("Строение", 		"Строение");
		СоотвествиеПолей.Вставить("Помещение", 		"Помещение");		
	ИначеЕсли (НЕ ЧастныйСектор = Неопределено И НЕ ЧастныйСектор) И (НЕ Строение = Неопределено И ЗначениеЗаполнено(Строение)) Тогда
		СоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
		СоотвествиеПолей.Вставить("Строение", 		"Строение");		
	ИначеЕсли НЕ ЧастныйСектор = Неопределено И ЧастныйСектор Тогда
		СоотвествиеПолей.Вставить("ЧастныйСектор", "ЧастныйСектор");
	КонецЕсли;
	Схема 										= Неопределено; 	
	ЗаполнитьСхемуЗапросаПромежуточнымиДанными(Схема,СоотвествиеПолей);
	ПолучитьПомежуточныеДанные(Схема, МВТ, СоотвествиеПолей);
	
КонецФункции

#КонецОбласти

#Область РеализацияИнтерефейса

Функция ЗначенияПараметровПоНаправлениямУслуг(МВТ) Экспорт 
	Возврат РегистрыСведений.энргСпособыРасчетаПоНаправлениям.ЗначенияПараметровПоНаправлениямУслуг(Организация,Район,ПериодНачисления)
КонецФункции

Функция ОписаниеКлючевыхПараметровНорматива() Экспорт  
	Возврат Перечисления.энргКлючевыеПараметрыНорматива.ОписаниеКлючевыхПараметров();
КонецФункции

Функция ДанныеКлючейНорматива() Экспорт  
	Возврат Справочники.энргКлючиНормативов.ДанныеКлючейНорматива();	 
КонецФункции

Функция ДокументыДляПроведения(МВТ) Экспорт 	
	Возврат ПолучитьДанныеВременнойТаблицы(МВТ,"ДокументыДляПроведения",ПоляПорядка)
КонецФункции 

Функция ДанныеДокументов(МВТ) Экспорт
	
	Схема 								= Новый СхемаЗапроса;
	Пакет  								= Схема.ПакетЗапросов[0];
	мИзмеренияИсключая 					= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИзмеренияИсключая,",");
	Операторы 							= Пакет.Операторы;
	
	Для Сч = 0 По ТаблицыДанных.ВГраница() Цикл
		Если Операторы.Количество() > Сч Тогда
			Оператор 					= Операторы[Сч];
		Иначе                      
			Оператор 					= Операторы.Добавить();
		КонецЕсли;	
		
		Источник 						= Оператор.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"),ТаблицыДанных[Сч],ТаблицыДанных[Сч]);
		
		Для Каждого Измерение ИЗ Метаданные.РегистрыСведений.энргСтабильныеПериоды.Измерения Цикл
			Если НЕ мИзмеренияИсключая.Найти(Измерение.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыДанных[Сч],Измерение.Имя,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;		
		
		ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыДанных[Сч],"ВидОперации","ЗНАЧЕНИЕ(Перечисление.энргВидыОпераций.ПустаяСсылка)");
		ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыДанных[Сч],"Порядок","0");
		ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыДанных[Сч],"КлючПомещения","ЗНАЧЕНИЕ(Справочник.энргКлючиПомещений.ПустаяСсылка)");
		
		Для Каждого Ресурсы ИЗ Метаданные.РегистрыСведений.энргСтабильныеПериоды.Ресурсы Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыДанных[Сч],Ресурсы.Имя,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;
	КонецЦикла;
	
	мПоляПорядка 							= СтрРазделить(ПоляПорядка,",");
	
	Для Сч = 0 По мПоляПорядка.ВГраница() Цикл
		Если Пакет.Колонки.Найти(мПоляПорядка[Сч]) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Пакет.Порядок.Добавить(мПоляПорядка[Сч]);
	КонецЦикла;	
	Пакет.Порядок.Добавить("Порядок");
	
	Запрос 							= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 	= МВТ;
	Возврат Запрос.Выполнить();
	
КонецФункции		 

Функция СостояниеНаГраницу(МВТ) Экспорт	
	Возврат ПолучитьДанныеВременнойТаблицы(МВТ,"СостояниеНаГраницуНарушенияПослеледовательности",ПоляПорядка);
КонецФункции

Функция СостояниеНаГраницуШкалы(МВТ) Экспорт
	Возврат ПолучитьДанныеВременнойТаблицы(МВТ,"СостояниеНаГраницуНарушенияПослеледовательности" + "Шкалы",ПоляПорядка); 
КонецФункции

Функция СостояниеНаГраницуИзмерители(МВТ) Экспорт  
	Возврат ПолучитьДанныеВременнойТаблицы(МВТ,"СостояниеНаГраницуНарушенияПослеледовательности" + "ИзмерителиНаправлений",ПоляПорядка);
КонецФункции

Функция ДанныеИзмененияСоставаШкал(МВТ) Экспорт 

	Измерения 							= "Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение,ДокРегистратор,ТочкаУчета,Шкала";	
	Схема 								= Новый СхемаЗапроса;
	Пакет  								= Схема.ПакетЗапросов[0];
	
	Операторы 							= Пакет.Операторы;
	мИзмерения 							= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Измерения,",");
	мПоляПорядка 						= СтрРазделить(ПоляПорядка,",");
	
	Для Сч = 0 По ТаблицыИзмененияШкал.ВГраница() Цикл
		Если Операторы.Количество() > Сч Тогда
			Оператор 					= Операторы[Сч];
		Иначе                      
			Оператор 					= Операторы.Добавить();
		КонецЕсли;	
		
		Источник 						= Оператор.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"),ТаблицыИзмененияШкал[Сч],ТаблицыДанных[Сч]);
		
		Для Каждого Измерение ИЗ мИзмерения Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияШкал[Сч],Измерение,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;		
		
		Для Каждого Ресурс ИЗ Метаданные.РегистрыСведений.энргСтабильныеПериодыШкалы.Ресурсы Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияШкал[Сч],Ресурс.Имя,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;
	КонецЦикла;
	
	Для Сч = 0 По мПоляПорядка.ВГраница() Цикл
		Если Пакет.Колонки.Найти(мПоляПорядка[Сч]) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Пакет.Порядок.Добавить(мПоляПорядка[Сч]);
	КонецЦикла;	
	
	Запрос 							= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 	= МВТ;
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ДанныеИзмененияСоставаИзмерителей(МВТ) Экспорт 

	Измерения 							= "Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение,ДокРегистратор,ТочкаУчета,Измеритель";	
	Схема 								= Новый СхемаЗапроса;
	Пакет  								= Схема.ПакетЗапросов[0];
	
	Операторы 							= Пакет.Операторы;
	мИзмерения 							= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Измерения,",");
	мПоляПорядка 						= СтрРазделить(ПоляПорядка,",");
	
	яМетаданные 						= Метаданные.РегистрыСведений.энргСтабильныеПериодыИзмерителиНаправлений;
	
	Для Сч = 0 По ТаблицыИзмененияИзмерителей.ВГраница() Цикл
		Если Операторы.Количество() > Сч Тогда
			Оператор 					= Операторы[Сч];
		Иначе                      
			Оператор 					= Операторы.Добавить();
		КонецЕсли;	
		
		Источник 						= Оператор.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"),ТаблицыИзмененияИзмерителей[Сч],ТаблицыДанных[Сч]);
		
		Для Каждого Измерение ИЗ мИзмерения Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияИзмерителей[Сч],Измерение,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;		
		
		Для Каждого Ресурс ИЗ яМетаданные.Ресурсы Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияИзмерителей[Сч],Ресурс.Имя,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;
	КонецЦикла;
	
	Для Сч = 0 По мПоляПорядка.ВГраница() Цикл
		Если Пакет.Колонки.Найти(мПоляПорядка[Сч]) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Пакет.Порядок.Добавить(мПоляПорядка[Сч]);
	КонецЦикла;	
	
	Запрос 							= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 	= МВТ;
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ДанныеДокументовИзмененияПлощади(МВТ) Экспорт 
	Измерения 							= "Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение,ДокРегистратор";	
	Ресурсы 							= "ВидПлощади,Значение" ;
	Схема 								= Новый СхемаЗапроса;
	Пакет  								= Схема.ПакетЗапросов[0];
	
	Операторы 							= Пакет.Операторы;
	мИзмерения 							= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Измерения,",");
	мРесурсы 							= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Ресурсы,",");
	мПоляПорядка 						= СтрРазделить(ПоляПорядка,",");
	
	Для Сч = 0 По ТаблицыИзмененияПлощади.ВГраница() Цикл
		Если Операторы.Количество() > Сч Тогда
			Оператор 					= Операторы[Сч];
		Иначе                      
			Оператор 					= Операторы.Добавить();
		КонецЕсли;	
		
		Источник 						= Оператор.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"),ТаблицыИзмененияПлощади[Сч],ТаблицыДанных[Сч]);
		
		Для Каждого Измерение ИЗ мИзмерения Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияПлощади[Сч],Измерение,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;		
		
		Для Каждого Ресурс ИЗ мРесурсы Цикл
			ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,Сч,ТаблицыИзмененияПлощади[Сч],Ресурс,"НЕОПРЕДЕЛЕНО");
		КонецЦикла;
	КонецЦикла;
	
	Для Сч = 0 По мПоляПорядка.ВГраница() Цикл
		Если Пакет.Колонки.Найти(мПоляПорядка[Сч]) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Пакет.Порядок.Добавить(мПоляПорядка[Сч]);
	КонецЦикла;	
	
	Запрос 							= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 	= МВТ;
	Возврат Запрос.Выполнить();	
КонецФункции

Функция ДействующуюРазрезыНорматива(МВТ) Экспорт 
	Схема 									= Неопределено;
	ПараметрыОтбора 						= Новый Структура;
	РегистрыСведений.энргУстановленныеПараметрыРасчетаНорматива.ДействующуюРазрезыНорматива(Схема,ПараметрыОтбора);
	Запрос 									= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("Район", 			Район);
	Запрос.УстановитьПараметр("МоментВремени",	ПериодНачисления);
	Запрос.УстановитьПараметр("ТипНачисления", 	Перечисления.энргТипыНачислений.ИндивидуальныеНачисления);
	Возврат Запрос.Выполнить(); 
КонецФункции

Функция ИзменяемыеПараметрыПоТипам() Экспорт 
	Возврат ИзменяемыеПараметрыПоТипам;	
КонецФункции

Процедура ПослеПроведенияПомещения(Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение) Экспорт 
	
	Если НЕ ЧастныйСектор = Неопределено Тогда 		
		Попытка
			РегистрыСведений.энргСтабильныеПериодыПоследовательность.УстановитьСостояниеПоследовательности(Организация,ПериодНачисления,Район,ЧастныйСектор,Строение,Помещение);
			НаборПериоды.Записать(Ложь);
			НаборШкалы.Записать(Ложь);
			НаборИзмерители.Записать(Ложь);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;  		
	КонецЕсли;
	
	НачатьТранзакцию();			
	
	НаборПериоды 							= РегистрыСведений.энргСтабильныеПериоды.СоздатьНаборЗаписей();
	НаборШкалы 								= РегистрыСведений.энргСтабильныеПериодыШкалы.СоздатьНаборЗаписей();
	НаборИзмерители 						= РегистрыСведений.энргСтабильныеПериодыИзмерителиНаправлений.СоздатьНаборЗаписей(); 
	
КонецПроцедуры

Процедура ПередПроведениемДокумента(ДокументДляПроведения) Экспорт 
	
	РегистрыСведений.энргСтабильныеПериоды.ОчиститьНаборы(ДокументДляПроведения);
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьДанныеВременнойТаблицы(МВТ,ИмяТаблицы,ПоляПорядка)
	
	Таблица 						= МВТ.Таблицы[ИмяТаблицы];
	Схема 							= Новый СхемаЗапроса;
	Пакет 							= Схема.ПакетЗапросов[0];
	Источник 						= Пакет.Операторы[0].Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"),ИмяТаблицы,ИмяТаблицы);
	Оператор 						= Пакет.Операторы[0];
	Для Каждого КолонкаВт ИЗ Таблица.Колонки Цикл
		ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник.Источник,Пакет.Колонки,МВТ,0,ИмяТаблицы,КолонкаВт.Имя,"");
	КонецЦикла;
	
	мПоляПорядка 					= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляПорядка);
	Для Сч = 0 По мПоляПорядка.ВГраница() Цикл
		Если Пакет.Колонки.Найти(мПоляПорядка[Сч]) = Неопределено Тогда
			Продолжить;
		КонецЕсли; 		
		Пакет.Порядок.Добавить(мПоляПорядка[Сч]);
	КонецЦикла;
		
	Запрос  						= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 	= МВТ;
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ЗаполнитьСхемуЗапросаПромежуточнымиДанными(Схема, СоотвествиеПолей)
	
	Параметры 								= Новый Массив;
	Параметры.Добавить(Новый Структура("ТипПараметра, СоотвествиеПолей", "ТипПараметраРавно", СоотвествиеПолей)); 
	
	РегистрыСведений.энргСтабильныеПериодыПоследовательность.НаборДокументовДляПроведения(Схема,Параметры,"ДокументыДляПроведения");	
	РегистрыСведений.энргСтабильныеПериоды.СостояниеНаГраницуНарушенияПослеледовательности(Схема,Параметры,"СостояниеНаГраницуНарушенияПослеледовательности");
	
	ИзменяемыеПараметрыПоТипам 				= Новый Соответствие;
	
	ТаблицыДанных	 						= Новый Массив;	
	ТипыОбъектовИзмененияСостояния			= Метаданные.ОпределяемыеТипы.энргОбъектыИзмененияСтабильногоПериода.Тип.Типы();
	Для Каждого ТипОбъекта Из ТипыОбъектовИзмененияСостояния Цикл
		МетаданныеИмя 						= Метаданные.НайтиПоТипу(ТипОбъекта);		
		Менеджер 							= Новый (Тип("ДокументМенеджер." + МетаданныеИмя.Имя));
		ТипСсылка 							= Тип("ДокументСсылка." + МетаданныеИмя.Имя);
		ИзменяемыеПараметрыРасчета 			= Менеджер.ИзменяемыеПараметрыРасчета();
		ИзменяемыеПараметрыПоТипам.Вставить(ТипСсылка, ИзменяемыеПараметрыРасчета);		
		Менеджер.ПолучитьДанныеДляПроведенияПоСтабильнымПериодам(Схема, ТаблицыДанных);		
	КонецЦикла;
	
	ТаблицыИзмененияПлощади  				= Новый Массив;
	ТипыОбъектовИзмененияПлощади 			= Метаданные.ОпределяемыеТипы.энргОбъектыИзмененияПлощади.Тип.Типы();
	Для Каждого ТипОбъекта Из ТипыОбъектовИзмененияПлощади Цикл
		МетаданныеИмя 						= Метаданные.НайтиПоТипу(ТипОбъекта);		
		Менеджер 							= Новый (Тип("ДокументМенеджер." + МетаданныеИмя.Имя));	
		ТипСсылка 							= Тип("ДокументСсылка." + МетаданныеИмя.Имя);
		Если ИзменяемыеПараметрыПоТипам[ТипСсылка] = Неопределено Тогда
			ИзменяемыеПараметрыРасчета 		= Менеджер.ИзменяемыеПараметрыРасчета();			
			ИзменяемыеПараметрыПоТипам.Вставить(ТипСсылка, ИзменяемыеПараметрыРасчета);
		КонецЕсли;
		Менеджер.ПолучитьДанныеИзмененияПлощади(Схема, ТаблицыИзмененияПлощади);		
	КонецЦикла;
	
	ТаблицыИзмененияШкал  					= Новый Массив;
	ТипыОбъектовИзмененияСоставаШкал		= Метаданные.ОпределяемыеТипы.энргОбъектыИзмененияШкал.Тип.Типы();
	Для Каждого ТипОбъекта Из ТипыОбъектовИзмененияСоставаШкал Цикл
		МетаданныеИмя 						= Метаданные.НайтиПоТипу(ТипОбъекта);		
		Менеджер 							= Новый (Тип("ДокументМенеджер." + МетаданныеИмя.Имя));	
		ТипСсылка 							= Тип("ДокументСсылка." + МетаданныеИмя.Имя);
		Если ИзменяемыеПараметрыПоТипам[ТипСсылка] = Неопределено Тогда
			ИзменяемыеПараметрыРасчета 		= Менеджер.ИзменяемыеПараметрыРасчета();		
			ИзменяемыеПараметрыПоТипам.Вставить(ТипСсылка, ИзменяемыеПараметрыРасчета);
		КонецЕсли;
		Менеджер.ПолучитьДанныеИзмененияСоставаШкал(Схема, ТаблицыИзмененияШкал);		
	КонецЦикла;
		
	ТаблицыИзмененияИзмерителей				= Новый Массив;
	ТипыОбъектовИзмененияСоставаШкал		= Метаданные.ОпределяемыеТипы.энргОбъектыИзмененияИзмерителей.Тип.Типы();
	Для Каждого ТипОбъекта Из ТипыОбъектовИзмененияСоставаШкал Цикл
		МетаданныеИмя 						= Метаданные.НайтиПоТипу(ТипОбъекта);		
		Менеджер 							= Новый (Тип("ДокументМенеджер." + МетаданныеИмя.Имя));	
		ТипСсылка 							= Тип("ДокументСсылка." + МетаданныеИмя.Имя);
		Если ИзменяемыеПараметрыПоТипам[ТипСсылка] = Неопределено Тогда
			ИзменяемыеПараметрыРасчета 		= Менеджер.ИзменяемыеПараметрыРасчета();		
			ИзменяемыеПараметрыПоТипам.Вставить(ТипСсылка, ИзменяемыеПараметрыРасчета);
		КонецЕсли;
		Менеджер.ПолучитьДанныеИзмененияИзмерителей(Схема, ТаблицыИзмененияИзмерителей);		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучитьПомежуточныеДанные(Схема, МВТ, СоотвествиеПолей)
	
	Запрос  								= Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.МенеджерВременныхТаблиц 			= Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", 			Организация);
	Запрос.УстановитьПараметр("ПериодНачисления", 		ПериодНачисления);
	Запрос.УстановитьПараметр("Район", 					Район);
	
	Если СоотвествиеПолей.Свойство("ЧастныйСектор") Тогда
		Запрос.УстановитьПараметр("ЧастныйСектор", 		ЧастныйСектор);	
	КонецЕсли;
	
	Если СоотвествиеПолей.Свойство("Строение") Тогда
		Запрос.УстановитьПараметр("Строение", 			Строение);	
	КонецЕсли;
	
	Если СоотвествиеПолей.Свойство("Помещение") Тогда
		Запрос.УстановитьПараметр("Помещение", 			Помещение);	
	КонецЕсли;
	
	Запрос.Выполнить();
	МВТ 									= Запрос.МенеджерВременныхТаблиц;
	
КонецПроцедуры

Процедура ДобавитьКолонкуЗапросаИзВременнойТаблицы(Оператор,Источник,КолонкиЗапроса,МВТ,Индекс,ИмяТаблицы,ИмяКолонки,ЗначениеПоУмолчанию) 
	
	Если НЕ МВТ.Таблицы[ИмяТаблицы].Колонки.Найти(ИмяКолонки) = Неопределено Тогда  
		КолонкаТаблицы 			= МВТ.Таблицы[ИмяТаблицы].Колонки[ИмяКолонки];
		Источник.ДоступныеПоля.Добавить(ИмяКолонки,КолонкаТаблицы.ТипЗначения);		
		Если Индекс = 0 Тогда
			Оператор.ВыбираемыеПоля.Добавить(КолонкаТаблицы.Имя);
			Колонка 			= КолонкиЗапроса[КолонкиЗапроса.Количество()-1];
			Колонка.Псевдоним 	= КолонкаТаблицы.Имя;
		Иначе
			Оператор.ВыбираемыеПоля.Добавить(КолонкаТаблицы.Имя, КолонкиЗапроса.Индекс(КолонкиЗапроса.Найти(ИмяКолонки)));
		КонецЕсли;
	Иначе
		Если Индекс = 0 Тогда
			Оператор.ВыбираемыеПоля.Добавить(ЗначениеПоУмолчанию);
			Колонка 			= КолонкиЗапроса[КолонкиЗапроса.Количество()-1];
			Колонка.Псевдоним 	= ИмяКолонки;
		Иначе
			Оператор.ВыбираемыеПоля.Добавить(ЗначениеПоУмолчанию, КолонкиЗапроса.Индекс(КолонкиЗапроса.Найти(ИмяКолонки)));
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

ИзмеренияИсключая  = "НомерПозиции";