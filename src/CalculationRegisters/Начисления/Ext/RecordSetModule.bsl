﻿#Область ПрограммныйИнтерфейс

Функция РассчитатьСуммуНачисления() Экспорт
    состояниеРасчетов =
        Новый Структура("ОстаткиДнейБолезниЗаСчетРаботодателя, ЗначенияМодифицированы", Новый Соответствие, Ложь);

    Для Каждого движение Из ЭтотОбъект Цикл
        результатРасчета = получитьСуммуНачисления(движение, состояниеРасчетов);

        Если результатРасчета.Успех Тогда
            Если НЕ состояниеРасчетов.ЗначенияМодифицированы И движение.Сумма <> результатРасчета.Сумма Тогда
                состояниеРасчетов.ЗначенияМодифицированы = Истина;
            КонецЕсли;

            движение.Сумма = результатРасчета.Сумма;

        Иначе
            ДиагностикаКлиентСервер.Утверждение(
                ТипЗнч(результатРасчета.Сообщение) = Тип("Строка")
                    И ЗначениеЗаполнено(результатРасчета.Сообщение),
                    "Текст сообщения об ошибке должен быть заполнен.");

            сообщение = Новый СообщениеПользователю;
            сообщение.Текст = результатРасчета.Сообщение;
            сообщение.Сообщить();
        КонецЕсли;
    КонецЦикла;

    Если состояниеРасчетов.ЗначенияМодифицированы Тогда
        ЭтотОбъект.Записать( , Истина);
    КонецЕсли;

    Возврат состояниеРасчетов.ЗначенияМодифицированы;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция получитьСуммуНачисления(Знач движение, Знач состояниеРасчетов)
    результатРасчета = Новый Структура("Сумма, Успех, Сообщение", 0, Истина, Неопределено);

    Если движение.ВидРасчета = ПланыВидовРасчета.Начисления.Оклад Тогда
        результатРасчета.Сумма = получитьСуммуНачисленияОклад(движение);

    ИначеЕсли движение.ВидРасчета = ПланыВидовРасчета.Начисления.Больничный Тогда
        // Определяем ткущий остаток дней больничного оплачиваемых за счет работодателя для сотрудника на начало расчета
        остатокДнейБолезниЗаСчетРаботодателя = состояниеРасчетов.ОстаткиДнейБолезниЗаСчетРаботодателя[движение.Сотрудник];
        // В случае отсутствия записи в состоянии по текущему сотруднику - обновляем состояние значением по умолчанию
        Если остатокДнейБолезниЗаСчетРаботодателя = Неопределено Тогда
            остатокДнейБолезниЗаСчетРаботодателя = получитьКоличествоДнейБольничногоЗаСчетРаботодателя();
            состояниеРасчетов.ОстаткиДнейБолезниЗаСчетРаботодателя.Вставить(
                движение.Сотрудник, остатокДнейБолезниЗаСчетРаботодателя);
        КонецЕсли;

        // Выполняем расчеты
        результатРасчетаПоБолезни = получитьСуммуНачисленияПоБолезни(движение, остатокДнейБолезниЗаСчетРаботодателя);
        результатРасчета.Сумма = результатРасчетаПоБолезни.Сумма;

        // Обновляем состояние расчетов
        состояниеРасчетов.ОстаткиДнейБолезниЗаСчетРаботодателя[движение.Сотрудник] =
            результатРасчетаПоБолезни.ОстатокДнейБолезниЗаСчетРаботодателя;

    ИначеЕсли движение.ВидРасчета.Предопределенный = Ложь Тогда
        результатРасчета.Сумма = 0;

    Иначе
        результатРасчета.Успех = Истина;
        результатРасчета.Сообщение = СтрШаблон("Для вида расчета %1 не задана формула расчета!", движение.ВидРасчета);
    КонецЕсли;

    Возврат результатРасчета;
КонецФункции

Функция получитьСуммуНачисленияОклад(Знач движение)
    оклад = движение.ПоказательРасчета;
    отработаноЧасов = движение.ПолучитьДанныеГрафика(ВидПериодаРегистраРасчета.ФактическийПериодДействия).Итог("КоличествоЧасов");
    нормаЧасов = движение.ПолучитьДанныеГрафика(ВидПериодаРегистраРасчета.ПериодДействия).Итог("КоличествоЧасов");

    Возврат оклад * отработаноЧасов / нормаЧасов;
КонецФункции

Функция получитьСуммуНачисленияПоБолезни(Знач движение, Знач остатокДнейБолезниЗаСчетРаботодателя)
    результат = Новый Структура("Сумма, ОстатокДнейБолезниЗаСчетРаботодателя", 0, остатокДнейБолезниЗаСчетРаботодателя);

    оклад = движение.ПоказательРасчета;
    стоимостьДняПоБолезни = рассчитатьСтоимостьДняПоБолезни(оклад);
    количествоДнейБолезни = рассчитатьКоличествоДнейБолезни(движение.ПериодДействияКонец, движение.ПериодДействияНачало);

    Если количествоДнейБолезни <= остатокДнейБолезниЗаСчетРаботодателя Тогда
        результат.Сумма = количествоДнейБолезни * стоимостьДняПоБолезни;
        результат.ОстатокДнейБолезниЗаСчетРаботодателя = результат.ОстатокДнейБолезниЗаСчетРаботодателя - количествоДнейБолезни;
    Иначе
        результат.Сумма = результат.ОстатокДнейБолезниЗаСчетРаботодателя * стоимостьДняПоБолезни;
        результат.ОстатокДнейБолезниЗаСчетРаботодателя = 0;
    КонецЕсли;

    Возврат результат;
КонецФункции

Функция получитьКоличествоДнейБольничногоЗаСчетРаботодателя()
    Возврат 3;
КонецФункции

Функция рассчитатьКоличествоДнейБолезни(Знач датаНачала, Знач датаОкончания)
    Возврат (КонецДня(датаНачала) + 1 - датаОкончания) / получитьКоличествоСекундВСутках();
КонецФункции

Функция рассчитатьСтоимостьДняПоБолезни(Знач оклад)
    Возврат оклад * 24 / 730;
КонецФункции

Функция получитьКоличествоСекундВСутках()
    Возврат 24 * 3600;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
