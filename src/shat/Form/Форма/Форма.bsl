﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализировать();
	НаДату = ТекущаяДата();
	УстановитьДоступностьЭлементовФормы();
	/////////
	Сообщить("Ляляля");


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнициироватьКонстантыШтатногоРасписания(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаВключения", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, "Вы уверены, что хотите активировать штатное расписание?", Режим, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаШтатногоРасписания(Команда)
	ОткрытьФорму("Обработка.ПанельНастроекЗарплатаКадры.Форма.НастройкаШтатногоРасписания");
КонецПроцедуры

&НаКлиенте
Процедура ПометкаСтарыхДанных(Команда)
	
	ПометкаСтарыхДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерепровестиКадровыеДокументы(Команда)
	
	ПерепровестиКадровыеДокументыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОкладыВШтатномРасписании(Команда)
	
	ЗаполнитьОкладыВШтатномРасписанииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТекущийСрезПоСотрудникам(Команда)
	
	ПолучитьТекущийСрезПоСотрудникамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьНовоеШтатноеРасписание(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните организацию!";
		Сообщение.Поле = "Организация";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Объект.Организация);
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.УтверждениеШтатногоРасписания.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РасформироватьНеДействующиеПодразделенияИДолжности(Команда)
	
	РасформироватьНеДействующиеПодразделенияИДолжностиНаСервере(НаДату);
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШтатноеРасписание(Команда)
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Инициализировать();
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры 

&НаСервере
Процедура ПометкаСтарыхДанныхНаСервере()

	УстановитьПривилегированныйРежим(Истина);

	// Установим пометку удаления на данные по штатному расписанию.
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаДляУдаленияДанных();
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.Ссылка) = Тип("СправочникСсылка.ШтатноеРасписание") Тогда
			
			Попытка
				ПозицияОбъект = Выборка.Ссылка.ПолучитьОбъект();
				
				Если НЕ ПозицияОбъект.ЭтоГруппа Тогда
					ПозицияОбъект.Наименование = УправлениеШтатнымРасписаниемКлиентСервер.НаименованиеПозицииШтатногоРасписания(ПозицияОбъект.Подразделение, ПозицияОбъект.Должность);
					ПозицияОбъект.КоличествоСтавок = 0;
					ПозицияОбъект.Утверждена = ложь;
					ПозицияОбъект.ДатаУтверждения = Дата(1, 1, 1);
					ПозицияОбъект.Закрыта = ложь;
					ПозицияОбъект.ДатаЗакрытия = Дата(1, 1, 1);
				КонецЕсли; 
				
				ПозицияОбъект.ПометкаУдаления = Истина;
				ПозицияОбъект.ОбменДанными.Загрузка = Истина;
				ПозицияОбъект.Записать();
			Исключение
				Сообщить("Ошибка установки пометки удаления: " + Строка(Выборка.Ссылка) + " " + Выборка.Ссылка.Код);		
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
			
		Иначе
			
			Попытка
				ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
				
				ДокументОбъект.ОбменДанными.Загрузка = Истина;
				//спрОбъект.УстановитьПометкуУдаления(Истина);
				ДокументОбъект.Проведен = Ложь;
				ДокументОбъект.ПометкаУдаления = Истина;
				ДокументОбъект.Записать();
			Исключение
				Сообщить("Ошибка установки пометки удаления: " + Строка(Выборка.Ссылка) + " " + Выборка.Ссылка.Номер);		
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
			
		КонецЕсли; 
	КонецЦикла;
	
	// Удаление помеченных объектов с контролем ссылочной целостности.
	Запрос.УстановитьПараметр("ПометкаУдаления", Истина);
	
	МассивПомеченных = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
    
    Если МассивПомеченных.Количество()>0 Тогда
		Попытка
			МассивФЗ = ФоновыеЗадания.ПолучитьФоновыеЗадания();
			Для каждого ФЗ Из МассивФЗ Цикл
				ФЗ.Отменить(); 
			КонецЦикла;
			
			УстановитьМонопольныйРежим(Истина);
            НеУдаляемые = Неопределено;
            УдалитьОбъекты(МассивПомеченных, Истина, НеУдаляемые);
			НеУдаляемые.Свернуть("Ссылка");				

			Для Каждого Ссылка Из НеУдаляемые Цикл
				Если ТипЗнч(Ссылка[0]) = Тип("СправочникСсылка.ШтатноеРасписание") Тогда
					Попытка
						ПозицияОбъект = Ссылка[0].ПолучитьОбъект();
						ПозицияОбъект.УстановитьПометкуУдаления(Ложь);
					Исключение
					КонецПопытки;
				КонецЕсли;
            КонецЦикла;
			УстановитьМонопольныйРежим(Ложь);
        Исключение
            Сообщить(ОписаниеОшибки());
        КонецПопытки;
	КонецЕсли;	
	
	Сообщить("Шаг 2: Старые данные по штатному расписанию удалены.");
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗаполнитьТаблицуДанныхДляУдаления();
	
КонецПроцедуры

&НаСервере
Процедура ПерепровестиКадровыеДокументыНаСервере()
	
	Для каждого Стр Из Объект.ТаблицаКадровыхДокументов Цикл
		ДокОбъект = Стр.Регистратор.ПолучитьОбъект();
		
		Попытка
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
	Сообщить("Шаг 3: Кадровые данные перепроведены.");

	ЗаполнитьТаблицуКадровыхДокументовДляПерепроведения();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОкладыВШтатномРасписанииНаСервере()
	
	Дерево = РеквизитФормыВЗначение("ДеревоСотрудников", Тип("ДеревоЗначений"));
	
	Если Дерево.Строки.Количество() = 0 Тогда
		Сообщить("Сформируйте данные для обработки!");		
		Возврат;		
	КонецЕсли;
	
	Для Каждого СтрокаПервогоУровня Из Дерево.Строки Цикл
		
		ОкладыСовпадают = Ложь;
		ТекущийОклад = 0;
		ПредыдущийОклад = 0;
		
		Для Каждого СтрокаВторогоУровня Из СтрокаПервогоУровня.Строки Цикл
			
			Если СтрокаВторогоУровня.Начисление = СтрокаВторогоУровня.НачислениеПоШтатномуРасписанию Тогда
				// Для позиции штатного расписания установлен оклад, ничего не делаем.
				Прервать;
			КонецЕсли;
			
			Если СтрокаПервогоУровня.Строки.Количество() = 1 Тогда
				// Если на позиции штатного расписания числится один сотрудник, то установим для позиции оклад.
				УстановитьОкладПозицииШтатногоРасписания(СтрокаВторогоУровня.ДолжностьПоШтатномуРасписанию, СтрокаВторогоУровня.Начисление, СтрокаВторогоУровня.Размер);
				Прервать;
			КонецЕсли;
			
			// Если на позиции штатного расписания числится несколько сотрудников и оклады всех сотрудников совпадают, 
			// то установим для позиции оклад.
			ТекущийОклад = СтрокаВторогоУровня.Размер;
			
			Если ПредыдущийОклад = 0 Тогда
				ПредыдущийОклад = ТекущийОклад;
				Продолжить;
			КонецЕсли;
			
			ОкладыСовпадают = ПредыдущийОклад = ТекущийОклад;
			
			Если НЕ ОкладыСовпадают Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ОкладыСовпадают Тогда
			УстановитьОкладПозицииШтатногоРасписания(СтрокаПервогоУровня.ДолжностьПоШтатномуРасписанию, СтрокаВторогоУровня.Начисление, ТекущийОклад);
		КонецЕсли;
		
	КонецЦикла;	
	
	Сообщить("Шаг 4: Установлены оклады в позициях штатного расписания.");

	ПолучитьТекущийСрезПоСотрудникамНаСервере();

КонецПроцедуры

&НаСервере
Процедура РасформироватьНеДействующиеПодразделенияИДолжностиНаСервере(Дата)
	
	// Расформируем не действующие подразделения и должности.
	Для каждого Стр Из Объект.ТаблицаПодразделенийИДолжностей Цикл
		
		Если ТипЗнч(Стр.Ссылка) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			
			ПодразделениеОбъект = Стр.Ссылка.ПолучитьОбъект();
			
			Попытка
				ПодразделениеОбъект.Расформировано = Истина;
				ПодразделениеОбъект.ДатаРасформирования = Дата;
				ПодразделениеОбъект.Записать();
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
			
		ИначеЕсли ТипЗнч(Стр.Ссылка) = Тип("СправочникСсылка.Должности") Тогда
			
			ДолжностьОбъект = Стр.Ссылка.ПолучитьОбъект();
			
			Попытка
				ДолжностьОбъект.ИсключенаИзШтатногоРасписания = Истина;
				ДолжностьОбъект.ДатаИсключения = Дата;
				ДолжностьОбъект.Записать();
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Сообщить("Шаг 5: Расформированы не действующие подразделения и должности.");

	ЗаполнитьТаблицуПодразделенийИДолжностейДляРасформирования();

КонецПроцедуры 

&НаСервере
Процедура СформироватьНаСервере()
	
	ЗаполнитьТаблицуПодразделенийИДолжностейДляРасформирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаВключения(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПослеЗакрытияВопросаВключенияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗакрытияВопросаВключенияНаСервере()

    АктивироватьНастройкиШтатного(Истина);
	УстановитьДоступностьЭлементовФормы();

КонецПроцедуры 

&НаСервере
Процедура ПолучитьТекущийСрезПоСотрудникамНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните организацию!";
		Сообщение.Поле = "Организация";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните дату!";
		Сообщение.Поле = "Дата";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НачислениеОклад) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните начисление по окладу!";
		Сообщение.Поле = "НачислениеОклад";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;		
	КонецЕсли;
	
	Обработка = РеквизитФормыВЗначение("Объект");
	СКД = Обработка.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Заполним параметры СКД.
	ПараметрыОтчета = СКД.Параметры;
	
	Параметр = ПараметрыОтчета.Организация;
    Параметр.Значение = Объект.Организация;
	
	Параметр = ПараметрыОтчета.Начисление;
    Параметр.Значение = Объект.НачислениеОклад;
	
	СКД.НастройкиПоУмолчанию.Отбор.Элементы[4].Использование = ТолькоПозицииСНезаполненнымОкладом;
	
	ОтчетОбъект = Новый Структура;
	ОтчетОбъект.Вставить("СхемаКомпоновкиДанных", СКД);
	
	ИнициализироватьОтчет(ОтчетОбъект);
	
	ДЗ = РезультатКомпоновкиВТЗ(СКД);
	
	Если ДЗ.Строки.Количество() > 1 Тогда
		ЗначениеВРеквизитФормы(ДЗ, "ДеревоСотрудников"); 
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтчет(Объект)
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(Объект);
КонецПроцедуры

Процедура Инициализировать()
	
	ЗаполнитьТаблицуДанныхДляУдаления();
	
	ЗаполнитьТаблицуКадровыхДокументовДляПерепроведения();

КонецПроцедуры

Процедура ЗаполнитьТаблицуКадровыхДокументовДляПерепроведения()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор,
		|	КадроваяИсторияСотрудников.Период КАК Дата,
		|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник,
		|	КадроваяИсторияСотрудников.Подразделение КАК Подразделение,
		|	КадроваяИсторияСотрудников.Должность КАК Должность,
		|	КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
		|	КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию.Подразделение КАК ДолжностьПоШтатномуРасписаниюПодразделение,
		|	КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию.Должность КАК ДолжностьПоШтатномуРасписаниюДолжность
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|ГДЕ
		|	(КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию.Должность <> КадроваяИсторияСотрудников.Должность
		|			ИЛИ КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию.Подразделение <> КадроваяИсторияСотрудников.Подразделение)
		|	И КадроваяИсторияСотрудников.Организация = &Организация
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Увольнение.Ссылка,
		|	Увольнение.Дата,
		|	Увольнение.Сотрудник,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL
		|ИЗ
		|	Документ.Увольнение КАК Увольнение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗанятыеПозицииШтатногоРасписания КАК ЗанятыеПозицииШтатногоРасписания
		|		ПО (ЗанятыеПозицииШтатногоРасписания.Регистратор = Увольнение.Ссылка)
		|ГДЕ
		|	Увольнение.Проведен = ИСТИНА
		|	И Увольнение.Организация = &Организация
		|	И ЗанятыеПозицииШтатногоРасписания.Регистратор ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Объект.ТаблицаКадровыхДокументов.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

Процедура ЗаполнитьТаблицуДанныхДляУдаления()

	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаДляУдаленияДанных();
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	
	Объект.ТаблицаДанныхДляУдаления.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

Процедура ЗаполнитьТаблицуПодразделенийИДолжностейДляРасформирования()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтатноеРасписание.Подразделение КАК Ссылка
		|ПОМЕСТИТЬ ВТДействующиеПодразделения
		|ИЗ
		|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Утверждена = ИСТИНА
		|	И ШтатноеРасписание.ГруппаПозицийПодразделения = ЛОЖЬ
		|	И ШтатноеРасписание.Владелец = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ШтатноеРасписание.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодразделенияОрганизаций.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТНеДействующиеПодразделения
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|ГДЕ
		|	ПодразделенияОрганизаций.Расформировано = ЛОЖЬ
		|	И НЕ ПодразделенияОрганизаций.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТДействующиеПодразделения.Ссылка КАК Ссылка
		|				ИЗ
		|					ВТДействующиеПодразделения КАК ВТДействующиеПодразделения)
		|	И ПодразделенияОрганизаций.Владелец = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШтатноеРасписание.Должность КАК Ссылка
		|ПОМЕСТИТЬ ВТДействующиеДолжности
		|ИЗ
		|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Утверждена = ИСТИНА
		|	И ШтатноеРасписание.ГруппаПозицийПодразделения = ЛОЖЬ
		|	И ШтатноеРасписание.Владелец = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ШтатноеРасписание.Должность
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Должности.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТНеДействующиеДолжности
		|ИЗ
		|	Справочник.Должности КАК Должности
		|ГДЕ
		|	Должности.ИсключенаИзШтатногоРасписания = ЛОЖЬ
		|	И НЕ Должности.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТДействующиеДолжности.Ссылка КАК Ссылка
		|				ИЗ
		|					ВТДействующиеДолжности КАК ВТДействующиеДолжности)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТНеДействующиеПодразделения.Ссылка КАК Ссылка,
		|	""Подразделение"" КАК ТипОбъекта
		|ИЗ
		|	ВТНеДействующиеПодразделения КАК ВТНеДействующиеПодразделения
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТНеДействующиеДолжности.Ссылка,
		|	""Должность""
		|ИЗ
		|	ВТНеДействующиеДолжности КАК ВТНеДействующиеДолжности
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТипОбъекта";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Объект.ТаблицаПодразделенийИДолжностей.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры 

Процедура АктивироватьНастройкиШтатного(Включить = Истина)
	Настройки = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	Если Включить = Истина Тогда
		
		Настройки.ДнейСохраненияБрони = 14;
		Настройки.ИспользоватьБронированиеПозиций = ЛОЖЬ;
		Настройки.ИспользоватьВилкуСтавокВШтатномРасписании = ЛОЖЬ;
		Настройки.ИспользоватьИндексациюШтатногоРасписания = ЛОЖЬ;
		Настройки.ИспользоватьИсториюИзмененияШтатногоРасписания = ИСТИНА;
		Настройки.ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании = ИСТИНА;
		Настройки.ИспользоватьШтатноеРасписание = ИСТИНА;
		Настройки.НеИспользоватьВилкуСтавокВШтатномРасписании = ИСТИНА;
		Настройки.НеИспользоватьИсториюИзмененияШтатногоРасписания = ЛОЖЬ;
		Настройки.НеИспользоватьШтатноеРасписание = ЛОЖЬ;
		Настройки.ПредставлениеТарифовИНадбавок = Перечисления.ПредставлениеТарифовИНадбавок.МесячныйРазмерВРублях;
		Настройки.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически = ЛОЖЬ;
		Настройки.УдалитьИспользоватьСтатьиФинансированияВКадровомУчете = ЛОЖЬ;
	Иначе	
		Настройки.ДнейСохраненияБрони = 14;
		Настройки.ИспользоватьБронированиеПозиций = ЛОЖЬ;
		Настройки.ИспользоватьВилкуСтавокВШтатномРасписании = ЛОЖЬ;
		Настройки.ИспользоватьИндексациюШтатногоРасписания = ЛОЖЬ;
		Настройки.ИспользоватьИсториюИзмененияШтатногоРасписания = ЛОЖЬ;
		Настройки.ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании = ЛОЖЬ;
		Настройки.ИспользоватьШтатноеРасписание = ЛОЖЬ;
		Настройки.НеИспользоватьВилкуСтавокВШтатномРасписании = ИСТИНА;
		Настройки.НеИспользоватьИсториюИзмененияШтатногоРасписания = ИСТИНА;
		Настройки.НеИспользоватьШтатноеРасписание = ИСТИНА;
		Настройки.ПредставлениеТарифовИНадбавок = Перечисления.ПредставлениеТарифовИНадбавок.ПустаяСсылка();
		Настройки.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически = ЛОЖЬ;
		Настройки.УдалитьИспользоватьСтатьиФинансированияВКадровомУчете = ЛОЖЬ;
		
	КонецЕсли; 
	
	//Настройки.Записать();
	УправлениеШтатнымРасписанием.ЗаписатьНастройкиШтатногоРасписания(Настройки);
	Сообщить("Шаг 1: Штатное расписание включено.");
КонецПроцедуры

Функция ПолучитьТекстЗапросаДляУдаленияДанных()
	
	Текст = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка КАК Ссылка,
	|	ВложенныйЗапрос.ТипОбъекта КАК ТипОбъекта
	|ИЗ
	|	(ВЫБРАТЬ
	|		ИзменениеШтатногоРасписания.Ссылка КАК Ссылка,
	|		""Изменение штатного расписания"" КАК ТипОбъекта,
	|		1 КАК Порядок
	|	ИЗ
	|		Документ.ИзменениеШтатногоРасписания КАК ИзменениеШтатногоРасписания
	|	ГДЕ
	|		ИзменениеШтатногоРасписания.ПометкаУдаления = &ПометкаУдаления
	|		И ИзменениеШтатногоРасписания.Организация = &Организация
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		УтверждениеШтатногоРасписания.Ссылка,
	|		""Утверждение штатного расписания"",
	|		0
	|	ИЗ
	|		Документ.УтверждениеШтатногоРасписания КАК УтверждениеШтатногоРасписания
	|	ГДЕ
	|		УтверждениеШтатногоРасписания.ПометкаУдаления = &ПометкаУдаления
	|		И УтверждениеШтатногоРасписания.Организация = &Организация
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ШтатноеРасписание.Ссылка,
	|		""Позиция штатного расписания"",
	|		2
	|	ИЗ
	|		Справочник.ШтатноеРасписание КАК ШтатноеРасписание
	|	ГДЕ
	|		ШтатноеРасписание.ПометкаУдаления = &ПометкаУдаления
	|		И ШтатноеРасписание.Владелец = &Организация) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Порядок";

	Возврат Текст;

КонецФункции 

Функция РезультатКомпоновкиВТЗ(СКД)

    КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
    КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);

	
    НастройкиКомпоновщика = КомпоновщикНастроек.Настройки;
    ПараметрыНастройки = НастройкиКомпоновщика.ПараметрыДанных;
	
	ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	ЗначениеПараметра.Значение = Объект.Дата;	
	
	//ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
	//// устанавливаем параметры отчета
	//ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	//ЗначениеПараметра.Значение = НачалоПериода;

	//ЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	//ЗначениеПараметра.Значение = КонецДня(КонецПериода);

    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СКД, НастройкиКомпоновщика,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

	//ТаблицаРезультат = Новый ТаблицаЗначений;
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	//ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	//ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ДеревоЗначений = Новый ДеревоЗначений;
	ПроцессорВывода.УстановитьОбъект(ДеревоЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);   

    Возврат ДеревоЗначений;

КонецФункции

Процедура УстановитьОкладПозицииШтатногоРасписания(Позиция, Начисление, Размер)

	ПозицияОбъект = Позиция.ПолучитьОбъект();
	
	ВсегоСтрок = ПозицияОбъект.Начисления.Количество();
	
	СтрНачисления = ПозицияОбъект.Начисления.Добавить();
	СтрНачисления.Начисление = Начисление;
	СтрНачисления.ИдентификаторСтрокиВидаРасчета = ВсегоСтрок + 1;
	СтрНачисления.Размер = Размер;
	
	СтрПоказатели = ПозицияОбъект.Показатели.Добавить();
	СтрПоказатели.Показатель = Справочники.ПоказателиРасчетаЗарплаты.Оклад; 
	СтрПоказатели.ИдентификаторСтрокиВидаРасчета = ВсегоСтрок + 1;
	СтрПоказатели.Значение = Размер;

	ПозицияОбъект.Записать();
	
КонецПроцедуры

Функция ИспользоватьШтатноеРасписание() 

	Настройки = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	Возврат Настройки.ИспользоватьШтатноеРасписание;

КонецФункции 
#Область ОбновлениеИнтерфейса

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Если ИспользоватьШтатноеРасписание() Тогда
		//Элементы.ГруппаШтатноеРасписание.Доступность = Ложь;
		Текст = "Штатное расписание используется."
	Иначе 
		Текст = "Штатное расписание не используется."
	КонецЕсли;
	
	Элементы.ДекорацияШтатноеРасписание.Заголовок = Текст;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
