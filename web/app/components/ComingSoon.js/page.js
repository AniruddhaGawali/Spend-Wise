"use client";
import React, { useEffect, useState } from "react";

export const ComingSoon = () => {
  const countDownDate = new Date("Jan 5, 2024 15:37:25").getTime();
  const [timeLeft, setTimeLeft] = useState({
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0,
  });

  useEffect(() => {
    const countdownFunction = setInterval(() => {
      const now = new Date().getTime();
      const distance = countDownDate - now;

      const days = Math.floor(distance / (1000 * 60 * 60 * 24));
      const hours = Math.floor(
        (distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
      );
      const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((distance % (1000 * 60)) / 1000);

      setTimeLeft({ days, hours, minutes, seconds });

      if (distance < 0) {
        clearInterval(countdownFunction);
        setTimeLeft({ days: 0, hours: 0, minutes: 0, seconds: 0 });
      }
    }, 1000);

    return () => clearInterval(countdownFunction);
  }, []);

  return (
    <>
      <div className="flex justify-center items-center h-screen bg-[url('/comingsoon1.jpg')] bg-cover bg-center">
        <div className="absolute overflow-hidden bg-gradient-to-r from-[rgb(0,0,0,.8)] to-[rgb(255,255,255,.3)] object-cover rounded-t-md  w-full h-full " />
        <div className="  text-white text-2xl py-5">
          <h1 className="relative text-6xl font-bold">Coming Soon!!!</h1>
          <div className="relative my-3">
            See you soon! On Jan 5, 2024.
          </div>
          <p style={{ fontSize: "50px",position: "relative"}}>
            {timeLeft.days}d {timeLeft.hours}h {timeLeft.minutes}m{" "}
            {timeLeft.seconds}s
          </p>
        </div>
      </div>
    </>
  );
};
