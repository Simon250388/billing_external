﻿#Область ОбработчикиСобытий

Процедура ЗарегистрироватьВПоследовательностиПриЗаписи(Источник, Отказ) Экспорт
	
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
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"энргСтабильныеПериодыПоследовательность");
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиМКДПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Источник.ДополнительныеСвойства.свойство("ВосстановлениеПоследовательности") тогда
		Возврат;
	КонецЕсли;
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"энргСтабильныеПериодыМКДПоследовательность");
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиПоказанияПУПриЗаписи(Источник, Отказ) Экспорт
	
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
	
	Набор = РегистрыСведений.энргПредоставленныеПоказания.СоздатьНаборЗаписей();
	Набор.Отбор.ДокРегистратор.Установить(Источник.ссылка);
	Набор.Записать();
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"энргПоказанияПУПоследовательность");
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиПоказанияМКДПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Источник.ДополнительныеСвойства.свойство("ВосстановлениеПоследовательности") тогда
		Возврат;
	КонецЕсли;	
	
	Источник.МассивПриборов();
	
	Набор = РегистрыСведений.энргПредоставленныеПоказанияМКД.СоздатьНаборЗаписей();
	Набор.Отбор.ДокРегистратор.Установить(Источник.ссылка);
	Набор.Записать();
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"энргПоказанияПУПоследовательностьМКД");
	
КонецПроцедуры

Процедура ЗарегистрироватьВПоследовательностиВзаиморасчеты(Источник, Отказ) Экспорт
		
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.свойство("ВосстановлениеПоследовательности") тогда
		Возврат;
	КонецЕсли;	
	
	Если Источник.ДополнительныеСвойства.свойство("НеРегестрироватьВзаиморасчеты") тогда
		Если Источник.ДополнительныеСвойства.НеРегестрироватьВзаиморасчеты тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗарегестрироватьВПоследовательности(Источник, Отказ,"энргВзаиморасчетыПоследовательность");
	
КонецПроцедуры

Процедура ЗарегестрироватьВПоследовательности(Источник, Отказ,ИмяПоследовательности)
		
	ПараметрыПриЧтении  	= Новый Структура;
	ПараметрыПриЧтении.вставить("ДокРегистратор",Источник.ссылка);	
	ЭтоНовый 				= Источник.ДополнительныеСвойства.Свойство("ЭтоНовый") и Источник.ДополнительныеСвойства.ЭтоНовый; 
	ДокументПроведен 		= Источник.Проведен;
	ПометкаУдаления 		= Источник.ПометкаУдаления;
	НаборЗаписей = РегистрыСведений[ИмяПоследовательности].СоздатьНаборЗаписей();
	для Каждого ЭлементОтбора из ПараметрыПриЧтении цикл
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("Массив") тогда
			Продолжить;
		КонецЕсли; 			
		НаборЗаписей.Отбор[ЭлементОтбора.ключ].установить(ЭлементОтбора.Значение);
	КонецЦикла;		
		
	// очищаем данные данные резултата проведения
	Если Не ЭтоНовый Тогда 
		
		НаборЗаписей.Прочитать();
		
		Если ИмяПоследовательности = "энргСтабильныеПериодыПоследовательность" тогда
			РезультатПроведения  	= РегистрыСведений.энргСтабильныеПериоды.СоздатьНаборЗаписей();
			РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
			РезультатПроведения.Записать();
			
			НаборНомераСтрок 		= РегистрыСведений.энргНомераСтрокСтабильногоПериода.СоздатьНаборЗаписей();
			НаборНомераСтрок.Отбор.ДокРегистратор.установить(Источник.ссылка);
			НаборНомераСтрок.Записать();
		ИначеЕсли ИмяПоследовательности = "энргСтабильныеПериодыМКДПоследовательность" тогда
			РезультатПроведения  	= РегистрыСведений.энргСтабильныеПериодыМКД.СоздатьНаборЗаписей();
			РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
			РезультатПроведения.Записать();
			
			НаборНомераСтрок 		= РегистрыСведений.энргНомераСтрокСтабильногоПериодаМКД.СоздатьНаборЗаписей();
			НаборНомераСтрок.Отбор.ДокРегистратор.установить(Источник.ссылка);
			НаборНомераСтрок.Записать();	
			
		ИначеЕсли ИмяПоследовательности = "энргПоказанияПУПоследовательность" тогда
			РезультатПроведения  	= РегистрыСведений.энргПредоставленныеПоказания.СоздатьНаборЗаписей();
			РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
			РезультатПроведения.Записать();	
			
			РезультатПроведения  	= РегистрыСведений.энргРасчетСреднегоОбъема.СоздатьНаборЗаписей();
			РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
			РезультатПроведения.Записать();
		ИначеЕсли ИмяПоследовательности = "бестСтабильныеПериодыПоследовательностьНП" тогда
			РезультатПроведения  = РегистрыСведений.бестСтабильныеПериодыПоследовательностьНП.СоздатьНаборЗаписей();
			РезультатПроведения.Отбор.ДокРегистратор.установить(Источник.ссылка);
			РезультатПроведения.Записать();	
		КонецЕсли;
	КонецЕсли;

	Если НЕ ДокументПроведен И НаборЗаписей.Количество() = 0 И НЕ Источник.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Запретить  Тогда
		// Документ непроведенный и прошлых записей в последовательности нет, поэтому менять нечего.
		Возврат;
	КонецЕсли;
	
	// Записи последовательности по прошлым организациям отметим, как требующие исключения.	
	ВГраница = НаборЗаписей.Количество() - 1;
	Для Сч = 0 По ВГраница Цикл
		
		Движение = НаборЗаписей[ВГраница - Сч];
		
		Если  ДокументПроведен ИЛИ (Источник.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Запретить и НЕ ПометкаУдаления) Тогда
			// Для проведенного документа состояние в последовательности определяем отдельно.
			НаборЗаписей.Удалить(Движение);
		ИначеЕсли Движение.СостояниеПроведения <> Перечисления.энргСостояниеДокументаВПоследовательности.ИсключенИзПоследовательности ИЛИ ПометкаУдаления Тогда
			Движение.СостояниеПроведения = Перечисления.энргСостояниеДокументаВПоследовательности.ИсключенИзПоследовательности;
		КонецЕсли;

	КонецЦикла;
	
	Если  ДокументПроведен ИЛИ (Источник.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Запретить И Не Источник.ПометкаУдаления)  тогда
		
		Если Источник.ДополнительныеСвойства.свойство("ГруппаАбонентов") тогда
			Если  Источник.ДополнительныеСвойства.ГруппаАбонентов тогда
				ЗарегестрироватьВПоследовательностиГруппуАбонентов(Источник,НаборЗаписей,ИмяПоследовательности);
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
			
			Если ИмяПоследовательности = "энргПоказанияПУПоследовательность" И Источник.ДополнительныеСвойства.Свойство("ПериодРегистрацииПоказаний") тогда
				ПериодРегистрации 	=  Источник.ДополнительныеСвойства.ПериодРегистрацииПоказаний;
			Иначе	
				ПериодРегистрации 	= Источник.дата;
			КонецЕсли;
						
			Если ПараметрыПроведения.свойство("ПериодРегистрации") тогда
				ПериодРегистрации = ПараметрыПроведения.ПериодРегистрации;
			КонецЕсли;
			
			Если Источник.ДополнительныеСвойства.свойство("МассивПриборов") тогда
				ПараметрыПроведения.вставить("МассивПриборовУчета",Источник.ДополнительныеСвойства.МассивПриборов);
			КонецЕсли;
			
			Если найти(ИмяПоследовательности,"НП") <> 0 тогда 
				ЗначенияИзмерений 						= Новый Структура(
				"Дата,Регистратор,ПериодНачисления,ПериодРегистрации,
				|Организация, Район, Договор, СостояниеПроведения,ПараметрыПроведения",
				Источник.Дата,Источник.Ссылка,ПараметрыПроведения.ПериодНачисления,ПериодРегистрации,
				ПараметрыПроведения.Организация,ПараметрыПроведения.Район,ПараметрыПроведения.Договор,СостояниеПроведения,ПараметрыПроведения);
			Иначе
				ЗначенияИзмерений 						= Новый Структура(
				"Дата,Регистратор,ПериодНачисления,ПериодРегистрации,
				|Организация, Район,СостояниеПроведения,ПараметрыПроведения",
				Источник.Дата,Источник.Ссылка,ПараметрыПроведения.ПериодНачисления,ПериодРегистрации,
				ПараметрыПроведения.Организация, ПараметрыПроведения.Район,СостояниеПроведения,ПараметрыПроведения);
			КонецЕсли;
			
			
			Если найти(ИмяПоследовательности,"МКД") <> 0 тогда 				
				ЗаполнитьЗначенияИзмеренийМКД(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);
			ИначеЕсли НЕ СтрНайти(ИмяПоследовательности,"Взаиморасчеты") = 0 Тогда
				ЗначенияИзмерений.Вставить("Абонент",Источник.Абонент);																									
				ЗаполнитьЗначенияИзмерений(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);
			Иначе				
				ЗначенияИзмерений.Вставить("Помещение",ПараметрыПроведения.Помещение);																									
				ЗаполнитьЗначенияИзмерений(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);
			КонецЕсли;	
			
			Если Источник.ДополнительныеСвойства.свойство("РазделенныйЛС") тогда
				Если  Источник.ДополнительныеСвойства.РазделенныйЛС тогда
					
					Если ЗначениеЗаполнено(ПараметрыПроведения.Помещение.Родитель) И ИмяПоследовательности = "энргСтабильныеПериодыПоследовательность" Тогда
					ПараметрыПроведения.Вставить("Помещение", ПараметрыПроведения.Помещение.Родитель);																								
					ЗаполнитьЗначенияИзмерений(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 	
	НаборЗаписей.Записать(); 	
КонецПроцедуры

Процедура ЗаполнитьЗначенияИзмерений(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений)
		
	ПараметрыПроведения 					= ЗначенияИзмерений.ПараметрыПроведения;
	Если ИмяПоследовательности = "энргПоказанияПУПоследовательность" Тогда 
		Выборка  								= ПараметрыПроведения.МассивПриборовУчета.выбрать();
		Пока Выборка.следующий() цикл 
			Движение 							= НаборЗаписей.Добавить();
			// Измерения
			Движение.ПериодНачисления 			= ЗначенияИзмерений.ПериодНачисления;
			Движение.Организация 	 			= ЗначенияИзмерений.Организация;
			Движение.Район 						= ЗначенияИзмерений.Район;
			Движение.ЧастныйСектор         	 	= ПараметрыПроведения.ЧастныйСектор;
			Движение.Строение              	 	= ПараметрыПроведения.Строение;
			Движение.Помещение 					= ПараметрыПроведения.Помещение;
			Движение.ПриборУчета				= Выборка.ПриборУчета;
			Движение.Разделитель				= Выборка.Разделитель;
			Движение.СостояниеПроведения 		= ЗначенияИзмерений.СостояниеПроведения;
			Движение.ПериодРегистрации 			= ЗначенияИзмерений.ПериодРегистрации;
			Движение.ДокРегистратор 			= ЗначенияИзмерений.Регистратор;
			Движение.ДатаРегистратора 			= ЗначенияИзмерений.Дата;
			Движение.ВыводПрибораУчета 			= Выборка.ВыводПрибораУчета;
			Движение.ИмяТабЧасти 				= Выборка.ИмяТабЧасти;
		КонецЦикла; 		
	ИначеЕсли ИмяПоследовательности = "энргСтабильныеПериодыПоследовательность" тогда
		Движение 								= НаборЗаписей.Добавить();
		Движение.Организация 	 				= ЗначенияИзмерений.Организация;
		Движение.ПериодНачисления 				= ЗначенияИзмерений.ПериодНачисления;
		Движение.Район 							= ЗначенияИзмерений.Район;
		Движение.ЧастныйСектор         	 		= ПараметрыПроведения.ЧастныйСектор;
		Движение.Строение              	 		= ПараметрыПроведения.Строение;
		Движение.Помещение 						= ПараметрыПроведения.Помещение;
		Движение.ПериодРегистрации 				= ЗначенияИзмерений.ПериодРегистрации;
		Движение.СостояниеПроведения 			= ЗначенияИзмерений.СостояниеПроведения;
		Движение.ДокРегистратор 				= ЗначенияИзмерений.Регистратор;
		Движение.ДатаРегистратора 				= ЗначенияИзмерений.Дата; 
	иначе
		Движение 								= НаборЗаписей.Добавить();
		Движение.Организация 	 				= ЗначенияИзмерений.Организация;
		Движение.ПериодНачисления 				= ЗначенияИзмерений.ПериодНачисления;
		Движение.Район 							= ЗначенияИзмерений.Район;
		Движение.МКД         	 				= ?(Не ПараметрыПроведения.ЧастныйСектор, ПараметрыПроведения.Строение, Справочники.энргСтроения.ПустаяСсылка());
		Движение.Абонент 						= ЗначенияИзмерений.Абонент;
		Движение.СостояниеПроведения 			= ЗначенияИзмерений.СостояниеПроведения;
		Движение.ДокРегистратор 				= ЗначенияИзмерений.Регистратор;
		Движение.ДатаРегистратора 				= ЗначенияИзмерений.Дата; 
		Движение.Сумма 							= ПараметрыПроведения.ДанныеОплаты.СуммаОплаты;
		Движение.ЭтоОплата 						= ПараметрыПроведения.ДанныеОплаты.ЭтоОплата;
		Движение.ПериодВзаиморасчетов			= ПараметрыПроведения.ДанныеОплаты.ПериодОплатыНачало;
		Движение.Услуга 						= ПараметрыПроведения.ДанныеОплаты.Услуга;
		Движение.Кассир 						= ПараметрыПроведения.Кассир;
		Движение.ИсточникПоступления 			= ПараметрыПроведения.ИсточникПоступления;
	КонецЕсли; 	
КонецПроцедуры

Процедура ЗаполнитьЗначенияИзмеренийМКД(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений)
	
	ПараметрыПроведения 					= ЗначенияИзмерений.ПараметрыПроведения;
	Если ИмяПоследовательности = "энргПоказанияПУПоследовательностьМКД" Тогда 
		Выборка  							= ПараметрыПроведения.МассивПриборовУчета.выбрать();
		Пока Выборка.следующий() цикл
			Движение 						= НаборЗаписей.Добавить();
			// Измерения
			Движение.Организация 	 		= ЗначенияИзмерений.Организация;
			Движение.ПериодНачисления 		= ЗначенияИзмерений.ПериодНачисления;
			Движение.Район 					= ЗначенияИзмерений.Район;
			Движение.МКД                    = ПараметрыПроведения.МКД;
			Движение.ПриборУчета			= Выборка.ПриборУчета;
			Движение.Разделитель			= Выборка.Разделитель;
			Движение.СостояниеПроведения 	= ЗначенияИзмерений.СостояниеПроведения;
			Движение.ПериодРегистрации 		= ЗначенияИзмерений.ПериодРегистрации;
			Движение.ДокРегистратор 		= ЗначенияИзмерений.Регистратор;
			Движение.ДатаРегистратора 		= ЗначенияИзмерений.Дата;
			Движение.ВыводПрибораУчета 		= Выборка.ВыводПрибораУчета;
			Движение.ИмяТабЧасти 			= Выборка.ИмяТабЧасти;
		КонецЦикла; 		
	иначе
		Движение 							= НаборЗаписей.Добавить();
		Движение.Организация 	 			= ЗначенияИзмерений.Организация;
		Движение.ПериодНачисления 			= ЗначенияИзмерений.ПериодНачисления;
		Движение.Район 						= ЗначенияИзмерений.Район;
		Движение.МКД                   		= ПараметрыПроведения.МКД; 		
		Движение.ПериодРегистрации 			= ЗначенияИзмерений.ПериодРегистрации;
		Движение.СостояниеПроведения 		= ЗначенияИзмерений.СостояниеПроведения;
		Движение.ДокРегистратор 			= ЗначенияИзмерений.Регистратор;
		Движение.ДатаРегистратора 			= ЗначенияИзмерений.Дата;  		
	КонецЕсли; 	
КонецПроцедуры

Процедура ЗаполнитьЗначенияИзмеренийНП(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений)
	
	ПараметрыПроведения 					= ЗначенияИзмерений.ПараметрыПроведения;
	Если  ИмяПоследовательности = "бестСтабильныеПериодыПоследовательностьНП" тогда
	
			Движение 							= НаборЗаписей.Добавить();
			Движение.Организация 	 			= ЗначенияИзмерений.Организация;
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

Процедура ЗарегестрироватьВПоследовательностиГруппуАбонентов(Источник,НаборЗаписей,ИмяПоследовательности)
	
	СостояниеПроведения  									= Перечисления.энргСостояниеДокументаВПоследовательности.ПроведенСНарушениемПоследовательности;
	
	Если ИмяПоследовательности ="энргПоказанияПУПоследовательность" тогда
		ДанныеДляПроведения  								= Источник.ДополнительныеСвойства.МассивПриборов;
		
		Выборка  											= ДанныеДляПроведения.выбрать();
		
		ТекКлючПомещения  									= Неопределено;
		ТекПриборУчета 										= Неопределено;
		ТекТарифнаяЗона 									= Неопределено;
		ТекРазделитель 										= 0;		
		Пока Выборка.следующий() цикл
			
			Если ТекКлючПомещения = Выборка.КлючПомещения и ТекПриборУчета = Выборка.ПриборУчета тогда
				ТекРазделитель 								= ТекРазделитель + 1;
			иначе
				ТекРазделитель 								= 0;
			КонецЕсли; 
			
			СтрокаНабора  									= НаборЗаписей.добавить();
			СтрокаНабора.Организация 	 					= Выборка.Организация;
			СтрокаНабора.ПериодНачисления  					= Выборка.ПериодНачисления;
			СтрокаНабора.Район  							= Выборка.Район;
			СтрокаНабора.СостояниеПроведения  				= СостояниеПроведения;
			СтрокаНабора.ЧастныйСектор		  				= Выборка.ЧастныйСектор;
			СтрокаНабора.Строение			  				= Выборка.Строение;
			СтрокаНабора.Помещение			  				= Выборка.Помещение;
			СтрокаНабора.ПриборУчета		  				= Выборка.ПриборУчета;
			СтрокаНабора.ПериодРегистрации	  				= Выборка.ПериодРегистрации;
			СтрокаНабора.ДатаРегистратора	  				= Источник.Дата;
			СтрокаНабора.ДокРегистратор	  					= Источник.ссылка;
			СтрокаНабора.ИмяТабЧасти	  					= Выборка.ИмяТабЧасти;
			СтрокаНабора.Разделитель	  					= ТекРазделитель;
			
			ТекКлючПомещения  								= Выборка.КлючПомещения;
			ТекПриборУчета 									= Выборка.ПриборУчета;
		//	ТекТарифнаяЗона 								= Выборка.ТарифнаяЗона;
		КонецЦикла; 		
	ИначеЕсли ИмяПоследовательности = "энргСтабильныеПериодыПоследовательность" тогда
		
		Источник.МассивПомещений();
		
		ДанныеДляПроведения  								= Источник.ДополнительныеСвойства.МассивПомещений;
		
		Выборка  											= ДанныеДляПроведения.выбрать();
		
		Пока Выборка.следующий() цикл
			СтрокаНабора 									= НаборЗаписей.Добавить();
			СтрокаНабора.Организация 	 					= Выборка.Организация;
			СтрокаНабора.ПериодНачисления 					= Выборка.ПериодНачисления;
			СтрокаНабора.Район 								= Выборка.Район;
			СтрокаНабора.ЧастныйСектор         	 			= Выборка.ЧастныйСектор;
			СтрокаНабора.Строение              	 			= Выборка.Строение;
			СтрокаНабора.Помещение 							= Выборка.Помещение;
			СтрокаНабора.ПериодРегистрации 					= Выборка.ПериодРегистрации;
			СтрокаНабора.СостояниеПроведения 				= СостояниеПроведения;
			СтрокаНабора.ДокРегистратор 					= Источник.ссылка;
			СтрокаНабора.ДатаРегистратора 					= Источник.Дата; 
			
		КонецЦикла;	
		
	ИначеЕсли ИмяПоследовательности ="энргВзаиморасчетыПоследовательность" тогда
		ДанныеДляПроведения  								= Источник.ДополнительныеСвойства.ДанныеОплаты;
		ИсточникПоступления 								= Источник.ДополнительныеСвойства.ИсточникПоступления;
		Выборка  											= ДанныеДляПроведения.выбрать();
		
		Пока Выборка.следующий() цикл
			СтрокаНабора 									= НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНабора,Выборка);
			СтрокаНабора.СостояниеПроведения 				= СостояниеПроведения;
			СтрокаНабора.ДокРегистратор 					= Источник.ссылка;
			СтрокаНабора.ДатаРегистратора 					= Выборка.Дата; 
			СтрокаНабора.Сумма 								= Выборка.СуммаОплаты;
			СтрокаНабора.ИсточникПоступления 				= ИсточникПоступления;			
		КонецЦикла;		
	КонецЕсли; 	
	
			
КонецПроцедуры

Процедура ЗарегестрироватьВПоследовательностиПомещениеСРазделеннымиЛС(Источник,НаборЗаписей,ИмяПоследовательности)
	
	СостояниеПроведения  									= Перечисления.энргСостояниеДокументаВПоследовательности.ПроведенСНарушениемПоследовательности;
	
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
	
	ЗначенияИзмерений 						= Новый Структура(
	"Дата,Регистратор,ПериодНачисления,ПериодРегистрации,
	|Организация, Район,СостояниеПроведения,ПараметрыПроведения",
	Источник.Дата,Источник.Ссылка,ПараметрыПроведения.ПериодНачисления,ПериодРегистрации,
	ПараметрыПроведения.Организация, ПараметрыПроведения.Район,СостояниеПроведения,ПараметрыПроведения);
	
	
	ЗначенияИзмерений.Вставить("Помещение",ПараметрыПроведения.Помещение.Родитель);																									
	ЗаполнитьЗначенияИзмерений(ИмяПоследовательности,НаборЗаписей,ЗначенияИзмерений);			
	
КонецПроцедуры

#КонецОбласти
