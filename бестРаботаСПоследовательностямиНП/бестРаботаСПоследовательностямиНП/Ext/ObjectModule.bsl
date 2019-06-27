﻿#Область ОбработчикиСобытий

Процедура ЗарегестрироватьВПоследовательности(Источник, Отказ,ИмяПоследовательности)
		
	ПараметрыПриЧтении  	= Новый Структура;
	ПараметрыПриЧтении.вставить("ДокРегистратор",Источник.ссылка);	
	
	// БлокируемыеЗначения  = Новый Структура;
	// БлокируемыеЗначения.Вставить("ДокРегистратор",Источник.ссылка);
		
	// УсеРаботаСПоследовательностями.
		// УстановитьБлокировкуНабораЗаписейПоследовательностиПоРегистратору(БлокируемыеЗначения,ИмяПоследовательности, Отказ);
	
	НаборЗаписей = РегистрыСведений[ИмяПоследовательности].СоздатьНаборЗаписей();
	для Каждого ЭлементОтбора из ПараметрыПриЧтении цикл
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("Массив") тогда
			Продолжить;
		КонецЕсли; 			
		НаборЗаписей.Отбор[ЭлементОтбора.ключ].установить(ЭлементОтбора.Значение);
	КонецЦикла;		
	НаборЗаписей.Прочитать();
	
	ДокументПроведен = Источник.Проведен;
	
	// очищаем данные данные резултата проведения
	Если ИмяПоследовательности = "бестСтабильныеПериодыПоследовательностьНП" тогда
		РезультатПроведения  = РегистрыСведений.бестСтабильныеПериодыПоследовательностьНП.СоздатьНаборЗаписей();
		РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
	    РезультатПроведения.Записать();	
	ИначеЕсли ИмяПоследовательности = "бестПоказанияПУНППоследовательность" тогда
		РезультатПроведения  = РегистрыСведений.бестПредоставленныеПоказанияНП.СоздатьНаборЗаписей();
		РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
	    РезультатПроведения.Записать();	
	КонецЕсли;
	
	
	Если НЕ ДокументПроведен И НаборЗаписей.Количество() = 0 Тогда
		// Документ непроведенный и прошлых записей в последовательности нет, поэтому менять нечего.
		Возврат;
	КонецЕсли;
	
	// Записи последовательности по прошлым организациям отметим, как требующие исключения.	
	ВГраница = НаборЗаписей.Количество() - 1;
	Для Сч = 0 По ВГраница Цикл
		
		Движение = НаборЗаписей[ВГраница - Сч];
		
		Если  ДокументПроведен Тогда
			// Для проведенного документа состояние в последовательности определяем отдельно.
			НаборЗаписей.Удалить(Движение);
		ИначеЕсли Движение.СостояниеПроведения <> Перечисления.энргСостояниеДокументаВПоследовательности.ИсключенИзПоследовательности Тогда
			Движение.СостояниеПроведения = Перечисления.энргСостояниеДокументаВПоследовательности.ИсключенИзПоследовательности;
		КонецЕсли;
	
	КонецЦикла;
	
	Если  ДокументПроведен тогда
		
		Если Источник.ДополнительныеСвойства.свойство("МассивОбъектов") тогда
			Если  Источник.ДополнительныеСвойства.МассивОбъектов тогда
				ЗарегестрироватьВПоследовательностиГруппуОбъектов(Источник,НаборЗаписей,ИмяПоследовательности);
			КонецЕсли;
						
		иначе

		
			ПараметрыПроведения  	= Источник.ДополнительныеСвойства.ПараметрыПроведения;	
			Если не ПараметрыПроведения.свойство("ДокРегистратор") тогда 
				ПараметрыПроведения.вставить("ДокРегистратор",Источник.ссылка);
			КонецЕсли;

			СостояниеПроведения 	= Перечисления.энргСостояниеДокументаВПоследовательности.ПроведенСНарушениемПоследовательности;
			
			Если Источник.ДополнительныеСвойства.Свойство("ПроведенВХронологическойПоследовательности") Тогда
				Если Источник.ДополнительныеСвойства.ПроведенВХронологическойПоследовательности Тогда
					СостояниеПроведения = Перечисления.энргСостояниеДокументаВПоследовательности.ПроведенВПоследовательности;
				КонецЕсли;
			КонецЕсли;
			
			ПериодРегистрации = Источник.дата;
						
			Если ПараметрыПроведения.свойство("ПериодРегистрации") тогда
				ПериодРегистрации = ПараметрыПроведения.ПериодРегистрации;
			КонецЕсли;
			
					
			Если Источник.ДополнительныеСвойства.свойство("МассивПриборов") тогда
				ПараметрыПроведения.вставить("МассивПриборовУчета",Источник.ДополнительныеСвойства.МассивПриборов);
			КонецЕсли;
			
				ЗначенияИзмерений 						= Новый Структура(
				"Дата,Регистратор,ПериодНачисления,ПериодРегистрации,
				|Организация, Район, Договор, СостояниеПроведения,ПараметрыПроведения",
				Источник.Дата,Источник.Ссылка,ПараметрыПроведения.ПериодНачисления,ПериодРегистрации,
				ПараметрыПроведения.Организация,ПараметрыПроведения.Район,ПараметрыПроведения.Договор,СостояниеПроведения,ПараметрыПроведения);
				
			ЗаполнитьЗначенияИзмеренийНП(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);
		КонецЕсли;	
	КонецЕсли; 	
	НаборЗаписей.Записать(); 	
КонецПроцедуры

Процедура ЗаполнитьЗначенияИзмеренийНП(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений)
	
	ПараметрыПроведения 					= ЗначенияИзмерений.ПараметрыПроведения;
	Если ИмяПоследовательности = "бестПоказанияПУНППоследовательность" Тогда 
		Выборка  								= ПараметрыПроведения.МассивПриборовУчета.выбрать();
		Пока Выборка.следующий() цикл 
			Движение 							= НаборЗаписей.Добавить();
			// Измерения
			Движение.ПериодНачисления 			= ЗначенияИзмерений.ПериодНачисления;
			Движение.Организация 	 			= ЗначенияИзмерений.Организация;
			Движение.Район 						= ЗначенияИзмерений.Район;
			Движение.Договор 					= ЗначенияИзмерений.Договор;
			Движение.ОбъектРасчета 				= Выборка.ОбъектРасчета;
			Движение.ПриборУчета				= Выборка.ПриборУчета;
			Движение.Разделитель				= Выборка.Разделитель;
			Движение.СостояниеПроведения 		= ЗначенияИзмерений.СостояниеПроведения;
			Движение.ПериодРегистрации 			= ЗначенияИзмерений.ПериодРегистрации;
			Движение.ДокРегистратор 			= ЗначенияИзмерений.Регистратор;
			Движение.ДатаРегистратора 			= ЗначенияИзмерений.Дата;
			Движение.ВыводПрибораУчета 			= Выборка.ВыводПрибораУчета;
			Движение.ИмяТабЧасти 				= Выборка.ИмяТабЧасти;
			Движение.МКД                   	 	= Выборка.ОбъектРасчета.МКД;
			
		КонецЦикла; 		
	ИначеЕсли  ИмяПоследовательности = "бестСтабильныеПериодыПоследовательностьНП" тогда
		
		Движение 							= НаборЗаписей.Добавить();
		Движение.ПериодНачисления 			= ЗначенияИзмерений.ПериодНачисления;
		Движение.Организация 				= ЗначенияИзмерений.Организация;
		Движение.Район 						= ЗначенияИзмерений.Район;
		Движение.Договор                   	= ЗначенияИзмерений.Договор; 
		Движение.СостояниеПроведения 		= ЗначенияИзмерений.СостояниеПроведения;
		Движение.ПериодРегистрации 			= ЗначенияИзмерений.ПериодРегистрации;
		Движение.ДокРегистратор 			= ЗначенияИзмерений.Регистратор;
		Движение.ДатаРегистратора 			= ЗначенияИзмерений.Дата;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиНППриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Источник.ДополнительныеСвойства.свойство("ВосстановлениеПоследовательности") тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.свойство("РегистрироватьСтабильныеПериоды") тогда
		Если не Источник.ДополнительныеСвойства.РегистрироватьСтабильныеПериоды тогда
			Возврат;
		КонецЕсли;  		
	КонецЕсли;
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"бестСтабильныеПериодыПоследовательностьНП");
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиПоказанияПУНППриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Источник.ДополнительныеСвойства.свойство("ВосстановлениеПоследовательности") тогда
		Возврат;
	КонецЕсли;	
	
	Если Источник.ДополнительныеСвойства.свойство("РегистрироватьПоказанияПУ") тогда
		Если не Источник.ДополнительныеСвойства.РегистрироватьПоказанияПУ тогда
			Возврат;
		КонецЕсли;  		
	КонецЕсли;
	
	Источник.МассивПриборов();

	Набор = РегистрыСведений.бестПредоставленныеПоказанияНП.СоздатьНаборЗаписей();
	Набор.Отбор.ДокРегистратор.Установить(Источник.ссылка);
	Набор.Записать();
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"бестПоказанияПУНППоследовательность");
	
КонецПроцедуры

Процедура ЗарегестрироватьВПоследовательностиГруппуОбъектов(Источник,НаборЗаписей,ИмяПоследовательности)
	
	СостояниеПроведения  									= Перечисления.энргСостояниеДокументаВПоследовательности.ПроведенСНарушениемПоследовательности;
	
	Если ИмяПоследовательности = "бестСтабильныеПериодыПоследовательностьНП" тогда
		
		Источник.МассивОбъектов();
		
		ДанныеДляПроведения  								= Источник.ДополнительныеСвойства.МассивОбъектов;
		
		Выборка  											= ДанныеДляПроведения.выбрать();
		
		Пока Выборка.следующий() цикл
			СтрокаНабора 									= НаборЗаписей.Добавить();
			СтрокаНабора.Организация 	 					= Выборка.Организация;
			СтрокаНабора.ПериодНачисления 					= Выборка.ПериодНачисления;
			СтрокаНабора.Район 								= Выборка.Район;
			СтрокаНабора.Договор	         	 			= Выборка.Договор;
			СтрокаНабора.ОбъектРасчета              	 	= Выборка.ОбъектРасчета;
			СтрокаНабора.ПериодРегистрации 					= Выборка.ПериодРегистрации;
			СтрокаНабора.СостояниеПроведения 				= СостояниеПроведения;
			СтрокаНабора.ДокРегистратор 					= Источник.ссылка;
			СтрокаНабора.ДатаРегистратора 					= Источник.Дата; 
			
		КонецЦикла;	
		
		
	КонецЕсли; 	
	
			
КонецПроцедуры

#КонецОбласти
