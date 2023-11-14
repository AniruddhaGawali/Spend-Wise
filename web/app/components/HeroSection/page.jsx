import React from "react";
import Image from "next/image";

export const HeroSection = () => {
  return (
    <div className="bg-[var(--gradient-start-color)] w-full shadow-2xl">
      <div className="container mx-auto flex flex-col md:flex-row justify-between items-center p-8">
        <div className="content text-center text-white md:w-1/2 md:my-20">
          <p className="mb-4 text-lg md:text-2xl">
            Streamlined expense management app for easy tracking,
            categorization, and control of your finances.
          </p>
          <h2 className="font-bold text-xl md:text-4xl mb-4 md:mt-10">Spend Wise</h2>
          <div className="flex flex-col md:flex-row justify-center items-center space-y-4 md:space-y-0 md:space-x-8 md:mt-16">
            <div className="flex flex-col items-center bg-black p-3 md:p-5 rounded-xl">
              <a href="https://github.com/AniruddhaGawali/Spend-Wise">
                <p>Get It On</p>
                <h2 className="font-bold">Github</h2>
              </a>
            </div>
            <div className="flex flex-col items-center bg-black p-3 md:p-5 rounded-xl mt-4 md:mt-0">
              <p>Coming Soon On</p>
              <h2 className="font-bold">Google Play</h2>
            </div>
          </div>
        </div>
        <div className="imgContainer flex items-end justify-end md:w-1/2 md:relative md:z-10 mt-8 md:mt-0">
          <div className="m-1">
            <Image src={"/product_img_4.jpg"} height={500} width={300} alt="SpendWise app Home" className="bg-contain rounded-3xl m-1" />
          </div>
          <div className="m-1">
            <Image src={"/product_img_1.jpg"} height={500} width={300} alt="SpendWise app Home" className="bg-contain rounded-3xl m-1" />
          </div>
          <div className="m-1">
            <Image src={"/product_img_3.jpg"} height={500} width={300} alt="SpendWise app Home" className="bg-contain rounded-3xl m-1" />
          </div>
        </div>
      </div>
    </div>
  );
};
