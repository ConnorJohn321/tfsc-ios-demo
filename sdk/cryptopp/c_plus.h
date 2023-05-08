

#ifndef c_plus_h
#define c_plus_h


#include "transaction.pb.h"
#include <string>

/**
 * @brief Get the Base58 object
 *
 * @param pkey
 * @return std::string
 */
std::string getBase58(const void *pkey);

/**
 * @brief Get the Pub Str object
 *
 * @param pkey
 * @return std::string
 */
std::string getPubStr(const void *pkey);

/**
 * @brief Get the Pri Str object
 *
 * @param pkey
 * @return std::string
 */
std::string getPriStr(const void * pkey);




std::string testSig(CTransaction& tx ,void * pkey);


std::string toSig(const std::string& data,void * pkey);

#endif /* c_plus_h */
