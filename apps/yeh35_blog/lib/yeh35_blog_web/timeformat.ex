defmodule Yeh35BlogWeb.Timeformat do
  @doc """
  Formats the given date into a string representation.

    Examples:
      iex> format_date(~D[2022-01-01])
      "2022년 1월 1일 토요일"

      iex> format_date(~D[2022-12-25])
      "2022년 12월 25일 일요일"

  """
  def format_date(date) do
    year = date.year
    month = date.month
    day = date.day
    day_of_week = date |> day_of_week()

    "#{year}년 #{month}월 #{day}일 #{day_of_week}"
  end

  defp day_of_week(date) do
    case Date.day_of_week(date) do
      1 -> "월요일"
      2 -> "화요일"
      3 -> "수요일"
      4 -> "목요일"
      5 -> "금요일"
      6 -> "토요일"
      7 -> "일요일"
    end
  end
end
