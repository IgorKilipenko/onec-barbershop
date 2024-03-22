﻿#Область ПрограммныйИнтерфейс

// Выполняет проверку является ли источник оповещения подчиненной формой
// Параметры:
//  формаВладелец - Форма
//  имяСобытия - Строка - Имя события из оповещения
//  параметрыСобытия - Произвольный
// Возвращаемое значение:
//  Булево
&НаКлиенте
Функция ПроверитьЭтоОповещениеПодчиненнойФормы(
        Знач формаВладелец, Знач имяСобытия, Знач параметрыСобытия) Экспорт

    Если параметрыСобытия = Неопределено Тогда
        Возврат Ложь;
    КонецЕсли;

    создательФормы = Неопределено;
    параметрыСобытия.Свойство("СоздательФормы", создательФормы);
    Если создательФормы <> формаВладелец.УникальныйИдентификатор Тогда
        Возврат Ложь;
    КонецЕсли;

    Возврат Истина;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
