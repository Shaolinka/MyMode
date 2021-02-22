-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Июл 09 2020 г., 22:38
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `russian_road_db`
--

-- --------------------------------------------------------

--
-- Структура таблицы `diaries`
--

CREATE TABLE IF NOT EXISTS `diaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `d_id` int(3) NOT NULL,
  `u_id` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `diaries`
--

INSERT INTO `diaries` (`id`, `d_id`, `u_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `diaries_posts`
--

CREATE TABLE IF NOT EXISTS `diaries_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `d_id` int(3) NOT NULL,
  `p_id` int(4) NOT NULL,
  `p_desc` varchar(145) NOT NULL,
  `p_date_of_creation` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `diaries_posts`
--

INSERT INTO `diaries_posts` (`id`, `d_id`, `p_id`, `p_desc`, `p_date_of_creation`) VALUES
(1, 1, 1, 'це тест йопта', '2020-07-04'),
(2, 1, 2, 'ауе басота', '2020-07-05');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
