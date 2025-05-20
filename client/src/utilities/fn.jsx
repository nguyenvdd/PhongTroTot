import {
  MdOutlineStarOutline,
  MdOutlineStarHalf,
  MdOutlineStarPurple500,
} from "react-icons/md"

export const generateRange = (start, end) => {
  const length = end + 1 - start
  return Array.from({ length }, (_, index) => start + index)
}
export const renderStar = (number = 0, size = 16) => {
  if (!Number(number)) return
  const stars = []
  if ((number * 10) % 2 === 0) {
    number = Math.round(number)
    for (let i = 0; i < +number; i++)
      stars.push(<MdOutlineStarPurple500 color="orange" size={size} />)
    for (let i = 5; i > +number; i--)
      stars.push(<MdOutlineStarOutline color="orange" size={size} />)
  } else {
    for (let i = 1; i <= Math.floor(+number); i++)
      stars.push(<MdOutlineStarPurple500 color="orange" size={size} />)
    stars.push(<MdOutlineStarHalf color="orange" size={size} />)
    for (let i = 5; i > Math.floor(+number) + 1; i--)
      stars.push(<MdOutlineStarOutline color="orange" size={size} />)
  }
  return stars
}
export const formatMoney = (number = 0) => {
  if (!Number(number)) return 0
  return Number(Number(number)?.toFixed(1)).toLocaleString()
}
export function getDaysInMonth(customTime, number) {
  const endDay = new Date(customTime)?.getDate() || new Date().getDate()
  const days = number || 15
  const endPreviousMonth = new Date(
    new Date(customTime)?.getFullYear(),
    new Date(customTime)?.getMonth(),
    0
  ).getDate()
  let day = 1
  let prevDayStart = 1
  const daysInMonths = []
  while (prevDayStart <= +endPreviousMonth) {
    const month = !isNaN(new Date(customTime).getMonth()) 
    ? new Date(customTime).getMonth() 
    : new Date().getMonth();
  
  const year = !isNaN(new Date(customTime).getFullYear()) 
    ? new Date(customTime).getFullYear() % 1000 
    : new Date().getFullYear() % 1000;
  
    daysInMonths.push(
      `${prevDayStart < 10 ? "0" + prevDayStart : prevDayStart}-${
        month < 10 ? `0${month}` : month
      }-${year}`
    )
    prevDayStart += 1
  }
  while (day <= +endDay) {
    const month = !isNaN(new Date(customTime).getMonth()) 
    ? new Date(customTime).getMonth() +1
    : new Date().getMonth() + 1; 
  
  const year = !isNaN(new Date(customTime).getFullYear()) 
    ? new Date(customTime).getFullYear() % 1000 
    : new Date().getFullYear() % 1000;
  
    daysInMonths.push(
      `${day < 10 ? "0" + day : day}-${
        month < 10 ? `0${month}` : month
      }-${year}`
    )
    day += 1
  }
  return daysInMonths.filter(
    (el, index, self) => index > self.length - days - 2
  )
}
export function getMonthInYear(customTime, number) {
  const startDate = customTime?.from ? new Date(customTime.from) : new Date();
  const endDate = customTime?.to ? new Date(customTime.to) : new Date();

  const startMonth = startDate.getMonth() + 1; 
  const endMonth = endDate.getMonth() + 1; 
  const startYear = startDate.getFullYear(); 
  const endYear = endDate.getFullYear(); 

  const months = number || 5; 
  const daysInMonths = [];

  for (let year = startYear; year <= endYear; year++) {
    for (let month = 1; month <= 12; month++) {
      if ((year === startYear && month >= startMonth) || (year === endYear && month <= endMonth) || (year > startYear && year < endYear)) {
        daysInMonths.push(`${month < 10 ? `0${month}` : month}-${year % 100}`); 
      }
    }
  }

  return daysInMonths.slice(-months); 
}


export const getDaysInRange = (start, end) => {
  const startDateTime = new Date(start).getTime()
  const endDateTime = new Date(end).getTime()
  return (endDateTime - startDateTime) / (24 * 60 * 60 * 1000)
}
export const getMonthsInRange = (start, end) => {
  let months
  const d1 = new Date(start)
  const d2 = new Date(end)
  months = (d2.getFullYear() - d1.getFullYear()) * 12
  months -= d1.getMonth()
  months += d2.getMonth()
  return months <= 0 ? 0 : months
}
