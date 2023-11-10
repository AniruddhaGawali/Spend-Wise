"use client";
import React, { useState, useEffect } from "react";
import Icon from "@mdi/react";
import { mdiWallet, mdiMenu } from "@mdi/js";
import Link from "next/link";

export const Navbar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);

  const handleScroll = () => {
    const scrollTop = window.scrollY;
    setIsScrolled(scrollTop > 0);
  };

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, []);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <div>
      <nav className={`relative flex px-5 h-16 mb-2 justify-between items-center shadow-md top-0 w-full ${isScrolled ? "bg-white text-black" : "bg-[var(--gradient-end-color)] text-white"}`}>
        <Link href="/" className="flex items-center">
          <Icon path={mdiWallet} size={1} className={`mx-1 ${isScrolled ? "text-[var(--gradient-start-color)]" : "text-white"}`} />
          <div className="text-xl font-semibold">Spend Wise</div>
        </Link>
        <div className="md:hidden relative">
          {/* Mobile Menu */}
          <button
            onClick={toggleMenu}
            className={`px-3 py-2 text-${isScrolled ? "black" : "white"}  focus:outline-none`}
          >
            <Icon path={mdiMenu} size={1} />
          </button>
          {isMenuOpen && (
            <div className={`absolute flex flex-col items-end mt-2 space-y-4 ${isScrolled ? "bg-white" : "bg-gray-800"} p-4 rounded-md`}>
              <Link href="/pages/login" className={`text-${isScrolled ? "black" : "white"} hover:text-gray-300`} onClick={toggleMenu}>
                LogIn
              </Link>
              <Link href="/pages/register" className={`text-${isScrolled ? "black" : "white"} hover:text-gray-300`} onClick={toggleMenu}>
                Register
              </Link>
              <Link href="/pages/terms" className={`text-${isScrolled ? "black" : "white"} hover:text-gray-300`} onClick={toggleMenu}>
                Terms
              </Link>
            </div>
          )}
        </div>
        <div className="hidden md:flex space-x-4">
          <Link href="/pages/login" className={`px-4 py-2 text-${isScrolled ? "black" : "white"} hover:bg-[var(--gradient-start-color)]`}>
            LogIn
          </Link>
          <Link href="/pages/register" className={`px-4 py-2 text-${isScrolled ? "black" : "white"} hover:bg-[var(--gradient-start-color)]`}>
            Register
          </Link>
          <Link href="/pages/terms" className={`px-4 py-2 text-${isScrolled ? "black" : "white"} hover:bg-[var(--gradient-start-color)]`}>
            Terms
          </Link>
        </div>
      </nav>
    </div>
  );
};
