import React from 'react';
import Image from 'next/image';

export const Footer = () => {
  return (
    <div className='w-full h-auto bg-white text-black p-4 md:p-8 relative bottom-0'>
      <div className="flex flex-col items-center md:flex-row justify-between">
        <div className='flex flex-col items-center md:items-start text-center md:text-left mb-4 md:mb-0'>
          <ul className="flex flex-col space-y-2 md:flex-row md:space-y-0 md:space-x-4 md:list-disc md:list-inside">
            <li><a href='/pages/terms'>Terms of Use</a></li>
            <li><a href='/pages/registerPage'>Register</a></li>
            <li><a href='/pages/logInPage'>LogIn</a></li>
          </ul>
          <p className="mt-2 md:mt-0">Copyright @2023 MindStack Inc. All rights reserved.</p>
        </div>
        <div className='flex justify-center items-center md:ml-8'>
          <h3 className="text-sm md:text-xl">Mindstack</h3>
          <Image src={'/Mindstack.png'} width={40} height={40} className="ml-2 rounded-3xl" />
        </div>
      </div>
    </div>
  )
};
